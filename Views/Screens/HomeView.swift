import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                topProfile
                balanceRow
                eventBanner
                quickActions
                dailyStreak
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 92)
        }
    }

    private var balanceRow: some View {
        HStack(spacing: 10) {
            CurrencyPill(icon: "bitcoinsign.circle.fill", value: store.coins.formattedCoins, color: NeonTheme.gold)
            CurrencyPill(icon: "diamond.fill", value: store.gems.formattedCoins, color: NeonTheme.cyan)
        }
    }

    private var topProfile: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(NeonTheme.neonGradient)
                    .frame(width: 58, height: 58)
                    .shadow(color: NeonTheme.cyan.opacity(0.6), radius: 14)
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 46))
                    .foregroundStyle(.black.opacity(0.75), .white)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(store.stats.name)
                    .font(.headline.weight(.heavy))
                Text("LV. \(store.stats.level)")
                    .font(.caption.bold())
                    .foregroundStyle(NeonTheme.cyan)
                ProgressGlow(value: Double(store.stats.xp) / Double(store.stats.xpGoal))
                    .frame(width: 92)
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 2)
    }

    private var eventBanner: some View {
        NeonPanel {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        RadialGradient(colors: [NeonTheme.pink.opacity(0.8), NeonTheme.purple.opacity(0.4), .black.opacity(0.25)], center: .center, startRadius: 10, endRadius: 220)
                    )
                    .frame(height: 162)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "7.circle.fill")
                            .font(.system(size: 96, weight: .black))
                            .foregroundStyle(NeonTheme.pink)
                            .shadow(color: NeonTheme.pink, radius: 22)
                            .padding(.trailing, 22)
                    }
                    .overlay(alignment: .topLeading) {
                        Text("FEATURED")
                            .font(.caption.bold())
                            .foregroundStyle(NeonTheme.cyan)
                            .padding(12)
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text("777 RUSH")
                        .font(.system(size: 35, weight: .black, design: .rounded))
                        .foregroundStyle(NeonTheme.pink)
                        .shadow(color: NeonTheme.pink, radius: 14)
                    Text("HIT 777. WIN BIG.")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.white.opacity(0.8))
                    Button {
                        store.select(.event)
                    } label: {
                        Text("PLAY NOW")
                            .font(.caption.weight(.black))
                            .padding(.horizontal, 28)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(NeonTheme.pink).shadow(color: NeonTheme.pink, radius: 10))
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
        }
    }

    private var quickActions: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            actionCard("PLAY", subtitle: "777 slots", icon: "gamecontroller.fill", tab: .play)
            actionCard("MISSIONS", subtitle: "earn rewards", icon: "scope", tab: .missions)
            actionCard("REWARDS", subtitle: "daily gifts", icon: "trophy.fill", tab: .rewards)
        }
    }

    private func actionCard(_ title: String, subtitle: String, icon: String, tab: AppTab) -> some View {
        Button {
            store.select(tab)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2.bold())
                    .foregroundStyle(NeonTheme.cyan)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .black, design: .rounded))
                    Text(subtitle.uppercased())
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.58))
                }
                Spacer()
            }
            .padding(12)
            .frame(height: 62)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.075))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.cyan.opacity(0.45), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }

    private var dailyStreak: some View {
        NeonPanel {
            VStack(alignment: .leading, spacing: 10) {
                Text("DAILY STREAK")
                    .font(.caption.weight(.black))
                    .foregroundStyle(NeonTheme.cyan)
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        VStack(spacing: 5) {
                            Circle()
                                .fill(day <= store.dailyStreak ? NeonTheme.neonGradient : LinearGradient(colors: [.white.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                                .frame(width: 30, height: 30)
                                .overlay(Text("\(day)").font(.caption.bold()))
                            Text("D\(day)")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white.opacity(0.55))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

}
