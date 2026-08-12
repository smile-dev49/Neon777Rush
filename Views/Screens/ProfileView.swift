import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                HeaderBar(title: "PROFILE", subtitle: "Offline player command center")
                profileCard
                statsGrid
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 96)
        }
    }

    private var profileCard: some View {
        NeonPanel {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(NeonTheme.neonGradient, lineWidth: 3)
                        .frame(width: 88, height: 88)
                        .shadow(color: NeonTheme.cyan.opacity(0.65), radius: 18)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 76))
                        .foregroundStyle(NeonTheme.cyan, NeonTheme.purple)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.stats.name)
                        .font(.title3.weight(.black))
                    Text("ID: 777RUSH2026")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.55))
                    ProgressGlow(value: Double(store.stats.xp) / Double(store.stats.xpGoal), color: NeonTheme.pink)
                    Text("\(store.stats.xp.formattedCoins) / \(store.stats.xpGoal.formattedCoins) XP")
                        .font(.caption2.bold())
                        .foregroundStyle(.white.opacity(0.58))
                }
                Spacer()
            }
        }
    }

    private var statsGrid: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                StatTile(title: "Level", value: "\(store.stats.level)", color: NeonTheme.cyan)
                StatTile(title: "VIP", value: store.stats.vipTier, color: NeonTheme.pink)
            }
            HStack(spacing: 10) {
                StatTile(title: "Total Spins", value: store.stats.totalSpins.formattedCoins)
                StatTile(title: "Biggest Win", value: store.stats.biggestWin.compactCoins, color: NeonTheme.gold)
            }
            HStack(spacing: 10) {
                StatTile(title: "Total Wins", value: "\(store.stats.totalWins)", color: NeonTheme.mint)
                StatTile(title: "Jackpots", value: "\(store.stats.jackpotsWon)", color: NeonTheme.pink)
            }
        }
    }

}
