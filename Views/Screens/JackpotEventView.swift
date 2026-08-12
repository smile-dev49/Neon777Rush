import SwiftUI

struct JackpotEventView: View {
    @EnvironmentObject private var store: GameStore
    @State private var pulse = false

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    HeaderBar(title: "777 EVENT", subtitle: "Limited-time offline jackpot rush")
                    hero
                    jackpotList
                    ticketPanel
                    NeonButton(title: "JOIN 777 EVENT", icon: "sparkles", prominent: true) {
                        store.joinEvent()
                    }
                    .disabled(store.tickets == 0)
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
                .padding(.bottom, 96)
            }
            BurstOverlay(active: store.jackpotBurst)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var hero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    RadialGradient(colors: [NeonTheme.pink.opacity(0.55), NeonTheme.purple.opacity(0.3), .black.opacity(0.52)], center: .center, startRadius: 10, endRadius: 230)
                )
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(NeonTheme.neonGradient, lineWidth: 1.2))
                .shadow(color: NeonTheme.pink.opacity(0.34), radius: 22)

            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    for index in 0..<8 {
                        var path = Path()
                        let y = size.height * CGFloat(0.15 + Double(index) * 0.1)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width * 0.36, y: y + CGFloat(sin(time + Double(index))) * 20))
                        path.addLine(to: CGPoint(x: size.width, y: y - CGFloat(cos(time + Double(index))) * 18))
                        context.stroke(path, with: .color(NeonTheme.cyan.opacity(0.22)), lineWidth: 2)
                    }
                }
            }

            VStack(spacing: 8) {
                Text("777")
                    .font(.system(size: 96, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.pink)
                    .shadow(color: NeonTheme.pink, radius: 30)
                    .scaleEffect(pulse ? 1.05 : 0.98)
                Text("SPIN, WIN, CONQUER")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.78))
                    .tracking(2)
                Text("EVENT ENDS IN 23:45:12")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.cyan)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.black.opacity(0.38)).overlay(Capsule().stroke(NeonTheme.cyan.opacity(0.55), lineWidth: 1)))
            }
        }
        .frame(height: 260)
    }

    private var jackpotList: some View {
        VStack(spacing: 8) {
            ForEach(store.jackpotValues, id: \.0) { jackpot in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(jackpot.0.uppercased())
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundStyle(jackpot.2)
                        Text(jackpot.1.formattedCoins)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                    }
                    Spacer()
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(jackpot.2)
                }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.06)).overlay(RoundedRectangle(cornerRadius: 8).stroke(jackpot.2.opacity(0.65), lineWidth: 1)))
            }
        }
    }

    private var ticketPanel: some View {
        NeonPanel {
            HStack(spacing: 12) {
                Image(systemName: "ticket.fill")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(NeonTheme.pink)
                VStack(alignment: .leading, spacing: 5) {
                    Text("YOUR TICKETS")
                        .font(.caption.weight(.black))
                        .foregroundStyle(.white.opacity(0.65))
                    Text("\(store.tickets)")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(NeonTheme.gold)
                }
                Spacer()
            }
        }
    }
}
