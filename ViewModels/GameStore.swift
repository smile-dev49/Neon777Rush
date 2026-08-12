import Foundation
import SwiftUI

@MainActor
final class GameStore: ObservableObject {
    @Published private(set) var state: GameState
    @Published var reels: [[SlotSymbol]]
    @Published var selectedTab: AppTab = .home
    @Published var isSpinning = false
    @Published var autoSpin = false
    @Published var turboMode = false
    @Published var jackpotBurst = false
    @Published var winPulse = false

    let jackpotValues = [
        ("Mega", 150_000_000, NeonTheme.pink),
        ("Grand", 25_000_000, NeonTheme.gold),
        ("Major", 5_000_000, NeonTheme.cyan),
        ("Minor", 1_000_000, NeonTheme.mint),
        ("Mini", 500_000, NeonTheme.green)
    ]

    private let storageKey = "neon777rush.gameState.v1"
    private let paylines = [
        [0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
        [2, 2, 2, 2, 2],
        [0, 1, 2, 1, 0],
        [2, 1, 0, 1, 2],
        [0, 0, 1, 2, 2],
        [2, 2, 1, 0, 0],
        [1, 0, 1, 2, 1]
    ]

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(GameState.self, from: data) {
            state = decoded
        } else {
            state = GameState()
        }
        reels = GameStore.randomReels()
    }

    var coins: Int { state.coins }
    var gems: Int { state.gems }
    var tickets: Int { state.tickets }
    var bet: Int { state.bet }
    var lastWin: Int { state.lastWin }
    var dailyStreak: Int { state.dailyStreak }
    var stats: PlayerStats { state.stats }
    var missions: [Mission] { state.missions }
    var rewards: [DailyReward] { state.rewards }

    func select(_ tab: AppTab) {
        SoundHapticsService.shared.play(.tap)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            selectedTab = tab
        }
    }

    func spin() {
        guard !isSpinning, state.coins >= state.bet else { return }
        SoundHapticsService.shared.play(.spin)
        isSpinning = true
        state.coins -= state.bet
        state.lastWin = 0
        updateMission("spin30", by: 1)
        state.stats.totalSpins += 1
        persist()

        let cycles = turboMode ? 6 : 14
        Task {
            for index in 0..<cycles {
                try? await Task.sleep(nanoseconds: UInt64(turboMode ? 42_000_000 : 82_000_000))
                reels = GameStore.randomReels(seed: index)
            }
            resolveSpin()
            isSpinning = false
            if autoSpin {
                try? await Task.sleep(nanoseconds: UInt64(turboMode ? 250_000_000 : 700_000_000))
                spin()
            }
        }
    }

    func toggleAutoSpin() {
        SoundHapticsService.shared.play(.tap)
        autoSpin.toggle()
        if autoSpin, !isSpinning {
            spin()
        }
    }

    func toggleTurbo() {
        SoundHapticsService.shared.play(.tap)
        turboMode.toggle()
    }

    func maxBet() {
        SoundHapticsService.shared.play(.tap)
        state.bet = min(1_000_000, max(50_000, state.coins / 4))
        persist()
    }

    func adjustBet(by delta: Int) {
        SoundHapticsService.shared.play(.tap)
        state.bet = min(max(50_000, state.bet + delta), 1_000_000)
        persist()
    }

    func claimMission(_ mission: Mission) {
        guard let index = state.missions.firstIndex(where: { $0.id == mission.id }),
              state.missions[index].isComplete,
              !state.missions[index].claimed else { return }
        SoundHapticsService.shared.play(.coin)
        state.coins += state.missions[index].rewardCoins
        state.gems += state.missions[index].rewardGems
        state.missions[index].claimed = true
        addXP(220)
        persist()
    }

    func claimAllMissions() {
        state.missions.filter { $0.isComplete && !$0.claimed }.forEach(claimMission)
    }

    func claimReward(_ reward: DailyReward) {
        guard let index = state.rewards.firstIndex(where: { $0.day == reward.day }),
              !state.rewards[index].claimed else { return }
        SoundHapticsService.shared.play(.coin)
        state.coins += state.rewards[index].coins
        state.gems += state.rewards[index].gems
        state.rewards[index].claimed = true
        state.dailyStreak = max(state.dailyStreak, reward.day)
        updateMission("daily", to: 1)
        addXP(reward.isChest ? 777 : 120)
        persist()
    }

    func joinEvent() {
        guard state.tickets > 0 else { return }
        SoundHapticsService.shared.play(.jackpot)
        state.tickets -= 1
        state.coins += 777_000
        addXP(777)
        jackpotBurst = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.jackpotBurst = false
        }
        persist()
    }

    private func resolveSpin() {
        let result = calculateWin()
        state.lastWin = result.win
        if result.win > 0 {
            SoundHapticsService.shared.play(result.isJackpot ? .jackpot : .win)
            state.coins += result.win
            state.stats.totalWins += 1
            state.stats.biggestWin = max(state.stats.biggestWin, result.win)
            updateMission("win2m", by: result.win)
            addXP(90 + result.matchCount * 40)
            winPulse = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.winPulse = false
            }
        }
        if result.sevenCombo {
            updateMission("hit777", by: 1)
        }
        if result.isJackpot {
            state.stats.jackpotsWon += 1
            jackpotBurst = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.jackpotBurst = false
            }
        }
        persist()
    }

    private func calculateWin() -> (win: Int, isJackpot: Bool, sevenCombo: Bool, matchCount: Int) {
        var total = 0
        var jackpot = false
        var sevenCombo = false
        var bestMatch = 0

        for line in paylines {
            let symbols = line.enumerated().map { reelIndex, rowIndex in
                reels[reelIndex][rowIndex]
            }
            guard let target = symbols.first(where: { $0 != .wild && $0 != .bonus }) else { continue }
            let matchCount = symbols.prefix { $0 == target || $0 == .wild }.count
            guard matchCount >= 3 else { continue }

            bestMatch = max(bestMatch, matchCount)
            let scale = matchCount == 3 ? 1 : matchCount == 4 ? 4 : 14
            total += max(target.baseMultiplier, 1) * scale * (state.bet / 10)
            if target == .seven {
                sevenCombo = true
            }
            if matchCount == 5 && target == .seven {
                jackpot = true
                total += jackpotValues[0].1
            }
        }

        let bonusCount = reels.flatMap { $0 }.filter { $0 == .bonus }.count
        if bonusCount >= 3 {
            total += state.bet * bonusCount * 3
        }

        return (total, jackpot, sevenCombo, bestMatch)
    }

    private func addXP(_ amount: Int) {
        state.stats.xp += amount
        while state.stats.xp >= state.stats.xpGoal {
            state.stats.xp -= state.stats.xpGoal
            state.stats.level += 1
            state.stats.xpGoal += 1_000
        }
    }

    private func updateMission(_ id: String, by amount: Int) {
        guard let index = state.missions.firstIndex(where: { $0.id == id }) else { return }
        state.missions[index].progress = min(state.missions[index].goal, state.missions[index].progress + amount)
    }

    private func updateMission(_ id: String, to progress: Int) {
        guard let index = state.missions.firstIndex(where: { $0.id == id }) else { return }
        state.missions[index].progress = min(state.missions[index].goal, progress)
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static func randomReels(seed: Int = 0) -> [[SlotSymbol]] {
        let weighted: [SlotSymbol] = [
            .seven, .diamond, .diamond, .coin, .coin, .coin, .cherry, .cherry,
            .star, .star, .lightning, .wild, .bonus
        ]
        return (0..<5).map { column in
            (0..<3).map { row in
                weighted.randomElement() ?? SlotSymbol.allCases[(column + row + seed) % SlotSymbol.allCases.count]
            }
        }
    }
}
