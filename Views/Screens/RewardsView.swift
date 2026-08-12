import SwiftUI

struct RewardsView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                HeaderBar(title: "REWARDS", subtitle: "7-day login rewards")
                rewardGrid
                NeonPanel {
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.badge.clock.fill")
                            .font(.title.bold())
                            .foregroundStyle(NeonTheme.gold)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NEXT VAULT")
                                .font(.caption.weight(.black))
                                .foregroundStyle(NeonTheme.cyan)
                            Text("Returns tomorrow with boosted coins, gems, and XP.")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.66))
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 96)
        }
    }

    private var rewardGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(store.rewards) { reward in
                rewardCard(reward)
                    .gridCellColumns(reward.isChest ? 2 : 1)
            }
        }
    }

    private func rewardCard(_ reward: DailyReward) -> some View {
        Button {
            store.claimReward(reward)
        } label: {
            VStack(spacing: 10) {
                Text("DAY \(reward.day)")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.78))
                ZStack {
                    if reward.isChest {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(NeonTheme.pink.opacity(0.25))
                            .frame(width: 100, height: 72)
                            .overlay(Image(systemName: "shippingbox.fill").font(.system(size: 52)).foregroundStyle(NeonTheme.gold))
                    } else {
                        Image(systemName: reward.gems > 0 ? "diamond.fill" : "bitcoinsign.circle.fill")
                            .font(.system(size: 42, weight: .black))
                            .foregroundStyle(reward.gems > 0 ? NeonTheme.cyan : NeonTheme.gold)
                    }
                }
                Text(reward.isChest ? "777 CHEST" : reward.gems > 0 ? "\(reward.gems) GEMS" : "\(reward.coins.compactCoins) COINS")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(reward.isChest ? NeonTheme.gold : .white)
                Text(reward.claimed ? "CLAIMED" : "TAP TO CLAIM")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(reward.claimed ? NeonTheme.mint : NeonTheme.pink)
            }
            .frame(maxWidth: .infinity)
            .frame(height: reward.isChest ? 176 : 148)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(reward.claimed ? 0.045 : 0.08))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke((reward.isChest ? NeonTheme.pink : NeonTheme.cyan).opacity(reward.claimed ? 0.35 : 0.85), lineWidth: 1.2))
                    .shadow(color: (reward.isChest ? NeonTheme.pink : NeonTheme.cyan).opacity(reward.claimed ? 0.16 : 0.34), radius: 16)
            )
        }
        .buttonStyle(.plain)
        .disabled(reward.claimed)
    }
}
