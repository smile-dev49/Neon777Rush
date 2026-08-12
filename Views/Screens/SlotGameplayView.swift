import SwiftUI

struct SlotGameplayView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    HeaderBar(title: "SLOT ARENA", subtitle: "Mega jackpot \(store.jackpotValues[0].1.formattedCoins)")
                    jackpotHeader
                    reelMachine
                    betPanel
                    spinControls
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 100)
            }
            BurstOverlay(active: store.jackpotBurst)
        }
    }

    private var jackpotHeader: some View {
        NeonPanel {
            VStack(spacing: 10) {
                Text("MEGA JACKPOT")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.pink)
                Text(store.jackpotValues[0].1.formattedCoins)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.gold)
                    .shadow(color: NeonTheme.gold, radius: 12)
                HStack(spacing: 7) {
                    ForEach(Array(store.jackpotValues.dropFirst()), id: \.0) { item in
                        JackpotTicker(title: item.0, value: item.1, color: item.2)
                    }
                }
            }
        }
    }

    private var reelMachine: some View {
        NeonPanel {
            VStack(spacing: 10) {
                HStack(spacing: 7) {
                    ForEach(0..<5, id: \.self) { reel in
                        VStack(spacing: 7) {
                            ForEach(0..<3, id: \.self) { row in
                                SlotSymbolTile(symbol: store.reels[reel][row], isSpinning: store.isSpinning)
                            }
                        }
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.58))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.pink.opacity(0.7), lineWidth: 1.3))
                        .shadow(color: NeonTheme.pink.opacity(0.38), radius: 22)
                )

                HStack {
                    lineBadge("25\nLINES")
                    Spacer()
                    lineBadge("WILD\nPAYS")
                    Spacer()
                    lineBadge("25\nLINES")
                }
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.76))
            }
        }
    }

    private func lineBadge(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .frame(width: 56, height: 42)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.purple.opacity(0.65), lineWidth: 1))
            )
    }

    private var betPanel: some View {
        HStack(spacing: 10) {
            stepperPanel(title: "TOTAL BET", value: store.bet.formattedCoins) {
                store.adjustBet(by: -50_000)
            } plus: {
                store.adjustBet(by: 50_000)
            }

            VStack(spacing: 4) {
                Text("WIN")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.gold)
                Text(store.lastWin.formattedCoins)
                    .font(.system(size: 19, weight: .black, design: .rounded))
                    .foregroundStyle(store.lastWin > 0 ? NeonTheme.gold : .white.opacity(0.72))
                    .lineLimit(1)
                    .minimumScaleFactor(0.58)
                    .scaleEffect(store.winPulse ? 1.08 : 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.07)).overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.gold.opacity(0.5), lineWidth: 1)))

            Button {
                store.maxBet()
            } label: {
                Text("MAX BET")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 86, height: 58)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.07)).overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.cyan.opacity(0.5), lineWidth: 1)))
            }
            .buttonStyle(.plain)
        }
    }

    private func stepperPanel(title: String, value: String, minus: @escaping () -> Void, plus: @escaping () -> Void) -> some View {
        HStack(spacing: 7) {
            Button(action: minus) {
                Image(systemName: "minus")
            }
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.56))
                Text(value)
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            Button(action: plus) {
                Image(systemName: "plus")
            }
        }
        .foregroundStyle(NeonTheme.cyan)
        .frame(width: 118, height: 58)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.07)).overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.cyan.opacity(0.5), lineWidth: 1)))
    }

    private var spinControls: some View {
        HStack(spacing: 10) {
            modeButton(title: "Turbo", icon: "bolt.fill", isOn: store.turboMode, action: store.toggleTurbo)
            modeButton(title: "Auto", icon: "repeat", isOn: store.autoSpin, action: store.toggleAutoSpin)
            NeonButton(title: store.isSpinning ? "SPINNING" : "SPIN", icon: nil, prominent: true) {
                store.spin()
            }
            .disabled(store.isSpinning)
            modeButton(title: "Bet", icon: "square.stack.3d.up.fill", isOn: false, action: store.maxBet)
        }
    }

    private func modeButton(title: String, icon: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .black))
                Text(title.uppercased())
                    .font(.system(size: 8, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.6)
            }
            .foregroundStyle(isOn ? NeonTheme.gold : NeonTheme.cyan)
            .frame(width: 58, height: 58)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.35))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke((isOn ? NeonTheme.gold : NeonTheme.cyan).opacity(0.55), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}
