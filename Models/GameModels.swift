import Foundation
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case play
    case missions
    case rewards
    case profile
    case event

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .play: return "Play"
        case .missions: return "Missions"
        case .rewards: return "Rewards"
        case .profile: return "Profile"
        case .event: return "Event"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .play: return "gamecontroller.fill"
        case .missions: return "checklist.checked"
        case .rewards: return "gift.fill"
        case .profile: return "person.crop.circle.fill"
        case .event: return "star.fill"
        }
    }

    static let navigationTabs: [AppTab] = [.home, .missions, .rewards, .profile, .event]
}

enum SlotSymbol: String, CaseIterable, Codable, Identifiable {
    case seven
    case diamond
    case coin
    case cherry
    case star
    case lightning
    case wild
    case bonus

    var id: String { rawValue }

    var title: String {
        switch self {
        case .seven: return "777"
        case .diamond: return "Diamond"
        case .coin: return "Coin"
        case .cherry: return "Cherry"
        case .star: return "Star"
        case .lightning: return "Bolt"
        case .wild: return "Wild"
        case .bonus: return "Bonus"
        }
    }

    var display: String {
        switch self {
        case .seven: return "777"
        case .diamond: return "diamond.fill"
        case .coin: return "bitcoinsign.circle.fill"
        case .cherry: return "circle.grid.cross.fill"
        case .star: return "star.fill"
        case .lightning: return "bolt.fill"
        case .wild: return "WILD"
        case .bonus: return "gift.fill"
        }
    }

    var color: Color {
        switch self {
        case .seven: return NeonTheme.pink
        case .diamond: return NeonTheme.cyan
        case .coin: return NeonTheme.gold
        case .cherry: return .red
        case .star: return NeonTheme.purple
        case .lightning: return .yellow
        case .wild: return NeonTheme.mint
        case .bonus: return .orange
        }
    }

    var baseMultiplier: Int {
        switch self {
        case .seven: return 24
        case .diamond: return 14
        case .coin: return 10
        case .cherry: return 7
        case .star: return 9
        case .lightning: return 12
        case .wild: return 0
        case .bonus: return 0
        }
    }
}

struct Mission: Identifiable, Codable {
    let id: String
    var title: String
    var subtitle: String
    var goal: Int
    var progress: Int
    var rewardCoins: Int
    var rewardGems: Int
    var claimed: Bool

    var isComplete: Bool { progress >= goal }
    var fraction: Double { min(Double(progress) / Double(goal), 1) }
}

struct DailyReward: Identifiable, Codable {
    let day: Int
    var coins: Int
    var gems: Int
    var isChest: Bool
    var claimed: Bool

    var id: Int { day }
}

struct PlayerStats: Codable {
    var name = "NeonPlayer"
    var level = 28
    var xp = 4_680
    var xpGoal = 8_000
    var totalSpins = 12_540
    var biggestWin = 25_000_000
    var totalWins = 256
    var jackpotsWon = 18
    var vipTier = "Diamond I"
}

struct GameState: Codable {
    var coins = 2_840_000
    var gems = 1_350
    var tickets = 12
    var bet = 250_000
    var lastWin = 0
    var dailyStreak = 4
    var stats = PlayerStats()
    var missions = GameState.defaultMissions
    var rewards = GameState.defaultRewards

    static let defaultMissions: [Mission] = [
        Mission(id: "spin30", title: "Spin 30 times", subtitle: "Spin the reels 30 times", goal: 30, progress: 18, rewardCoins: 10_000, rewardGems: 0, claimed: false),
        Mission(id: "win2m", title: "Win 2,000,000 coins", subtitle: "Win coins in any mode", goal: 2_000_000, progress: 1_200_000, rewardCoins: 20_000, rewardGems: 0, claimed: false),
        Mission(id: "hit777", title: "Hit 777 combo 5 times", subtitle: "Land 777 combo on reels", goal: 5, progress: 2, rewardCoins: 0, rewardGems: 25, claimed: false),
        Mission(id: "daily", title: "Claim daily reward", subtitle: "Claim your daily reward", goal: 1, progress: 1, rewardCoins: 5_000, rewardGems: 0, claimed: false)
    ]

    static let defaultRewards: [DailyReward] = [
        DailyReward(day: 1, coins: 10_000, gems: 0, isChest: false, claimed: true),
        DailyReward(day: 2, coins: 0, gems: 10, isChest: false, claimed: true),
        DailyReward(day: 3, coins: 25_000, gems: 0, isChest: false, claimed: true),
        DailyReward(day: 4, coins: 0, gems: 20, isChest: false, claimed: false),
        DailyReward(day: 5, coins: 50_000, gems: 0, isChest: false, claimed: false),
        DailyReward(day: 6, coins: 0, gems: 30, isChest: false, claimed: false),
        DailyReward(day: 7, coins: 777_000, gems: 77, isChest: true, claimed: false)
    ]
}
