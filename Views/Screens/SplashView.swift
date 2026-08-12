import SwiftUI

struct SplashView: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            NeonBackground()

            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    for index in 0..<11 {
                        var path = Path()
                        let x = size.width * CGFloat((Double(index) * 0.137 + time * 0.08).truncatingRemainder(dividingBy: 1))
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x + 42, y: size.height * 0.25))
                        path.addLine(to: CGPoint(x: x - 22, y: size.height * 0.52))
                        path.addLine(to: CGPoint(x: x + 28, y: size.height))
                        context.stroke(path, with: .color((index.isMultiple(of: 2) ? NeonTheme.cyan : NeonTheme.pink).opacity(0.32)), lineWidth: 2)
                    }
                }
            }

            VStack(spacing: 18) {
                Text("NEON")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.cyan)
                    .shadow(color: NeonTheme.cyan, radius: 24)
                Text("777")
                    .font(.system(size: 92, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.pink)
                    .shadow(color: NeonTheme.pink, radius: 34)
                    .scaleEffect(pulse ? 1.08 : 0.98)
                Text("RUSH")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.neonGradient)
                    .shadow(color: NeonTheme.purple, radius: 22)
                ProgressGlow(value: pulse ? 0.95 : 0.35, color: NeonTheme.pink)
                    .frame(width: 220)
                    .padding(.top, 18)
                Text("CYBER JACKPOT LOADING")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.74))
                    .tracking(3)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
