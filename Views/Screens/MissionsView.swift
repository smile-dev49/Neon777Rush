import SwiftUI

struct MissionsView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                HeaderBar(title: "MISSIONS", subtitle: "Daily objectives and cyber rewards")
                ForEach(store.missions) { mission in
                    missionCard(mission)
                }
                NeonButton(title: "CLAIM ALL", icon: "tray.full.fill") {
                    store.claimAllMissions()
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 96)
        }
    }

    private func missionCard(_ mission: Mission) -> some View {
        NeonPanel {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(mission.isComplete ? NeonTheme.mint.opacity(0.28) : NeonTheme.cyan.opacity(0.18))
                        .frame(width: 52, height: 52)
                        .overlay(Circle().stroke(mission.isComplete ? NeonTheme.mint : NeonTheme.cyan, lineWidth: 1))
                    Image(systemName: mission.isComplete ? "checkmark.seal.fill" : "calendar.badge.clock")
                        .font(.title2.bold())
                        .foregroundStyle(mission.isComplete ? NeonTheme.mint : NeonTheme.cyan)
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text(mission.title)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                    Text(mission.subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.62))
                    ProgressGlow(value: mission.fraction, color: mission.isComplete ? NeonTheme.mint : NeonTheme.cyan)
                    Text("\(mission.progress.formattedCoins) / \(mission.goal.formattedCoins)")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                }

                VStack(spacing: 8) {
                    Image(systemName: mission.rewardGems > 0 ? "diamond.fill" : "bitcoinsign.circle.fill")
                        .font(.title2.bold())
                        .foregroundStyle(mission.rewardGems > 0 ? NeonTheme.cyan : NeonTheme.gold)
                    Text(mission.rewardGems > 0 ? "\(mission.rewardGems)" : mission.rewardCoins.compactCoins)
                        .font(.system(size: 12, weight: .black, design: .rounded))
                    Button {
                        store.claimMission(mission)
                    } label: {
                        Text(mission.claimed ? "DONE" : "CLAIM")
                            .font(.system(size: 9, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(mission.isComplete && !mission.claimed ? NeonTheme.pink : Color.white.opacity(0.12)))
                    }
                    .buttonStyle(.plain)
                    .disabled(!mission.isComplete || mission.claimed)
                }
                .frame(width: 58)
            }
        }
    }
}
