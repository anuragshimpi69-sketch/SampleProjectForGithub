import SwiftUI

// MARK: - Lotus Flower Shape
struct LotusShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cx = rect.midX
        let cy = rect.midY
        let w = rect.width
        let h = rect.height

        var path = Path()

        // Center petal (top)
        path.move(to: CGPoint(x: cx, y: cy + h * 0.10))
        path.addQuadCurve(
            to: CGPoint(x: cx, y: cy - h * 0.40),
            control: CGPoint(x: cx - w * 0.15, y: cy - h * 0.15)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx, y: cy + h * 0.10),
            control: CGPoint(x: cx + w * 0.15, y: cy - h * 0.15)
        )

        // Left petal
        path.move(to: CGPoint(x: cx - w * 0.02, y: cy + h * 0.08))
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.30, y: cy - h * 0.18),
            control: CGPoint(x: cx - w * 0.28, y: cy + h * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.02, y: cy + h * 0.08),
            control: CGPoint(x: cx - w * 0.08, y: cy - h * 0.22)
        )

        // Right petal
        path.move(to: CGPoint(x: cx + w * 0.02, y: cy + h * 0.08))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.30, y: cy - h * 0.18),
            control: CGPoint(x: cx + w * 0.28, y: cy + h * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.02, y: cy + h * 0.08),
            control: CGPoint(x: cx + w * 0.08, y: cy - h * 0.22)
        )

        // Far left petal
        path.move(to: CGPoint(x: cx - w * 0.05, y: cy + h * 0.12))
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.38, y: cy + h * 0.0),
            control: CGPoint(x: cx - w * 0.30, y: cy + h * 0.16)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx - w * 0.05, y: cy + h * 0.12),
            control: CGPoint(x: cx - w * 0.18, y: cy - h * 0.05)
        )

        // Far right petal
        path.move(to: CGPoint(x: cx + w * 0.05, y: cy + h * 0.12))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.38, y: cy + h * 0.0),
            control: CGPoint(x: cx + w * 0.30, y: cy + h * 0.16)
        )
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.05, y: cy + h * 0.12),
            control: CGPoint(x: cx + w * 0.18, y: cy - h * 0.05)
        )

        // Base arc
        path.move(to: CGPoint(x: cx - w * 0.18, y: cy + h * 0.20))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.18, y: cy + h * 0.20),
            control: CGPoint(x: cx, y: cy + h * 0.30)
        )

        return path
    }
}

// MARK: - App Icon View (Lotus in rounded square)
struct AppIconView: View {
    let size: CGFloat

    init(size: CGFloat = 70) {
        self.size = size
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.calmDeepPurple,
                            Color.calmMidPurple,
                            Color.calmCTABlue
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: Color.calmDeepPurple.opacity(0.5), radius: 12, x: 0, y: 6)

            LotusShape()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size * 0.55, height: size * 0.55)
        }
    }
}
