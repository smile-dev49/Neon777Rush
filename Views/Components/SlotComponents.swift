import SwiftUI

struct SlotSymbolTile: View {
    let symbol: SlotSymbol
    var isSpinning = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black.opacity(0.34))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(symbol.color.opacity(0.65), lineWidth: 1)
                )
                .shadow(color: symbol.color.opacity(0.55), radius: isSpinning ? 18 : 8)

            if symbol == .seven || symbol == .wild {
                Text(symbol.display)
                    .font(.system(size: symbol == .seven ? 27 : 16, weight: .black, design: .rounded))
                    .foregroundStyle(symbol.color)
                    .shadow(color: symbol.color, radius: 9)
                    .minimumScaleFactor(0.62)
            } else {
                Image(systemName: symbol.display)
                    .font(.system(size: 27, weight: .black))
                    .foregroundStyle(symbol.color)
                    .shadow(color: symbol.color, radius: 10)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(isSpinning ? 0.94 : 1)
        .animation(.easeInOut(duration: 0.12), value: isSpinning)
    }
}

struct JackpotTicker: View {
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(color)
            Text(value.compactCoins)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black.opacity(0.35))
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(color.opacity(0.8), lineWidth: 1))
                .shadow(color: color.opacity(0.35), radius: 10)
        )
    }
}

struct StatTile: View {
    let title: String
    let value: String
    var color: Color = NeonTheme.cyan

    var body: some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.55))
            Text(value)
                .font(.system(size: 17, weight: .heavy, design: .rounded))
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white.opacity(0.055))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.25), lineWidth: 1))
        )
    }
}

struct BurstOverlay: View {
    let active: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                guard active else { return }
                let time = timeline.date.timeIntervalSinceReferenceDate
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                for index in 0..<34 {
                    let angle = Double(index) / 34 * Double.pi * 2
                    let radius = 30 + CGFloat((time.truncatingRemainder(dividingBy: 1.0))) * 190
                    var path = Path()
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius))
                    let color = index.isMultiple(of: 2) ? NeonTheme.gold : NeonTheme.pink
                    context.stroke(path, with: .color(color.opacity(0.5)), lineWidth: 2)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
