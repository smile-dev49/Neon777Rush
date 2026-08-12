import SwiftUI

enum NeonTheme {
    static let background = Color(red: 0.015, green: 0.018, blue: 0.055)
    static let panel = Color(red: 0.035, green: 0.055, blue: 0.14)
    static let cyan = Color(red: 0.08, green: 0.84, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.05, blue: 0.55)
    static let purple = Color(red: 0.55, green: 0.18, blue: 1.0)
    static let gold = Color(red: 1.0, green: 0.72, blue: 0.18)
    static let mint = Color(red: 0.27, green: 1.0, blue: 0.64)
    static let green = Color(red: 0.3, green: 0.95, blue: 0.35)

    static let screenGradient = LinearGradient(
        colors: [background, Color(red: 0.04, green: 0.02, blue: 0.12), Color(red: 0.01, green: 0.035, blue: 0.09)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let neonGradient = LinearGradient(
        colors: [cyan, pink, purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Int {
    var compactCoins: String {
        let value = Double(self)
        if abs(self) >= 1_000_000 {
            return String(format: "%.1fM", value / 1_000_000).replacingOccurrences(of: ".0", with: "")
        }
        if abs(self) >= 1_000 {
            return String(format: "%.1fK", value / 1_000).replacingOccurrences(of: ".0", with: "")
        }
        return "\(self)"
    }

    var formattedCoins: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

struct NeonBackground: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for index in 0..<42 {
                    let x = (sin(time * 0.25 + Double(index) * 1.7) + 1) * size.width / 2
                    let y = (cos(time * 0.2 + Double(index) * 1.13) + 1) * size.height / 2
                    let rect = CGRect(x: x, y: y, width: 2.2, height: 2.2)
                    let color = index.isMultiple(of: 2) ? NeonTheme.cyan : NeonTheme.pink
                    context.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.55)))
                }

                for index in 0..<7 {
                    var path = Path()
                    let baseY = size.height * (0.14 + CGFloat(index) * 0.12)
                    let phase = CGFloat(sin(time + Double(index)))
                    path.move(to: CGPoint(x: -20, y: baseY))
                    path.addLine(to: CGPoint(x: size.width * 0.28, y: baseY + phase * 12))
                    path.addLine(to: CGPoint(x: size.width * 0.62, y: baseY - phase * 8))
                    path.addLine(to: CGPoint(x: size.width + 20, y: baseY + phase * 10))
                    context.stroke(path, with: .color(NeonTheme.cyan.opacity(0.08)), lineWidth: 1)
                }
            }
        }
        .background(NeonTheme.screenGradient)
        .ignoresSafeArea()
    }
}

struct NeonPanel<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    init(cornerRadius: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(NeonTheme.neonGradient, lineWidth: 1)
                    )
                    .shadow(color: NeonTheme.cyan.opacity(0.28), radius: 12)
                    .shadow(color: NeonTheme.pink.opacity(0.18), radius: 18)
            )
    }
}

struct NeonButton: View {
    let title: String
    let icon: String?
    var prominent = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.system(size: prominent ? 20 : 13, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.72)
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: prominent ? 58 : 46)
            .background(
                RoundedRectangle(cornerRadius: prominent ? 29 : 8, style: .continuous)
                    .fill(NeonTheme.neonGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: prominent ? 29 : 8, style: .continuous)
                            .stroke(.white.opacity(0.45), lineWidth: 1)
                    )
                    .shadow(color: NeonTheme.pink.opacity(0.62), radius: prominent ? 22 : 10)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct CurrencyPill: View {
    let icon: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .frame(height: 36)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.07))
                .overlay(Capsule().stroke(color.opacity(0.45), lineWidth: 1))
        )
    }
}

struct HeaderBar: View {
    let title: String
    let subtitle: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(NeonTheme.neonGradient)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.68))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 18)
    }
}

struct ProgressGlow: View {
    let value: Double
    var color: Color = NeonTheme.cyan

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.11))
                Capsule()
                    .fill(LinearGradient(colors: [color, NeonTheme.pink], startPoint: .leading, endPoint: .trailing))
                    .frame(width: geometry.size.width * min(max(value, 0), 1))
                    .shadow(color: color.opacity(0.8), radius: 8)
            }
        }
        .frame(height: 7)
    }
}

struct BottomNav: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppTab.navigationTabs) { tab in
                Button {
                    store.select(tab)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: .bold))
                        Text(tab.title.uppercased())
                            .font(.system(size: 8, weight: .heavy, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .foregroundStyle(store.selectedTab == tab ? NeonTheme.cyan : .white.opacity(0.58))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.46))
                .overlay(Capsule().stroke(NeonTheme.cyan.opacity(0.35), lineWidth: 1))
                .shadow(color: NeonTheme.cyan.opacity(0.25), radius: 15)
        )
        .padding(.horizontal, 14)
        .padding(.bottom, 8)
    }
}
