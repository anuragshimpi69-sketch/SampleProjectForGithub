import SwiftUI

// MARK: - Star Field Background
struct StarFieldView: View {
    @State private var twinklePhase = false

    let starCount: Int

    init(starCount: Int = 30) {
        self.starCount = starCount
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Crescent Moon
                CrescentMoon()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 28, height: 28)
                    .shadow(color: Color.white.opacity(0.6), radius: 8, x: 0, y: 0)
                    .position(x: geo.size.width * 0.18, y: geo.size.height * 0.08)

                // Small stars
                ForEach(0..<starCount, id: \.self) { i in
                    let seed = StarSeed(index: i, bounds: geo.size)
                    Circle()
                        .fill(Color.white)
                        .frame(width: seed.size, height: seed.size)
                        .opacity(twinklePhase ? seed.opacity1 : seed.opacity2)
                        .shadow(color: .white.opacity(0.5), radius: seed.size)
                        .position(x: seed.x, y: seed.y)
                        .animation(
                            Animation.easeInOut(duration: seed.duration)
                                .repeatForever(autoreverses: true)
                                .delay(seed.delay),
                            value: twinklePhase
                        )
                }

                // A few sparkle/cross stars
                ForEach(0..<4, id: \.self) { i in
                    let sparkle = SparkleSeed(index: i, bounds: geo.size)
                    SparkleShape()
                        .fill(Color.white.opacity(twinklePhase ? 0.9 : 0.3))
                        .frame(width: sparkle.size, height: sparkle.size)
                        .position(x: sparkle.x, y: sparkle.y)
                        .animation(
                            Animation.easeInOut(duration: 2.0 + Double(i) * 0.3)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.5),
                            value: twinklePhase
                        )
                }
            }
        }
        .onAppear { twinklePhase = true }
    }
}

// MARK: - Crescent Moon Shape
struct CrescentMoon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2

        path.addArc(center: center, radius: r,
                    startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        let offset = r * 0.6
        let cutCenter = CGPoint(x: center.x + offset, y: center.y - offset * 0.3)
        path.addArc(center: cutCenter, radius: r * 0.85,
                    startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

        return path.applying(CGAffineTransform(translationX: 0, y: 0))
    }

    var fillStyle: FillStyle {
        FillStyle(eoFill: true)
    }

    func path(in rect: CGRect, fillStyle: inout FillStyle) -> Path {
        fillStyle = FillStyle(eoFill: true)
        return path(in: rect)
    }
}

// MARK: - Sparkle/Cross Star Shape
struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        let inner = r * 0.25

        var path = Path()
        for i in 0..<4 {
            let angle = Double(i) * .pi / 2
            let outerX = cx + CGFloat(cos(angle)) * r
            let outerY = cy + CGFloat(sin(angle)) * r
            let nextAngle = angle + .pi / 4
            let innerX = cx + CGFloat(cos(nextAngle)) * inner
            let innerY = cy + CGFloat(sin(nextAngle)) * inner

            if i == 0 {
                path.move(to: CGPoint(x: outerX, y: outerY))
            } else {
                path.addLine(to: CGPoint(x: outerX, y: outerY))
            }
            path.addLine(to: CGPoint(x: innerX, y: innerY))
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Deterministic star seeds
struct StarSeed {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity1: Double
    let opacity2: Double
    let duration: Double
    let delay: Double

    init(index: Int, bounds: CGSize) {
        let hash = Self.simpleHash(index)
        x = CGFloat(hash % 1000) / 1000.0 * bounds.width
        y = CGFloat((hash / 7) % 1000) / 1000.0 * bounds.height * 0.5  // top half
        size = CGFloat(1.5 + Double(hash % 3))
        opacity1 = 0.4 + Double(hash % 50) / 100.0
        opacity2 = 0.1 + Double(hash % 30) / 100.0
        duration = 1.5 + Double(hash % 200) / 100.0
        delay = Double(hash % 300) / 100.0
    }

    static func simpleHash(_ n: Int) -> Int {
        var h = n &* 2654435761
        h = h ^ (h >> 16)
        return abs(h)
    }
}

struct SparkleSeed {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat

    init(index: Int, bounds: CGSize) {
        let positions: [(CGFloat, CGFloat)] = [
            (0.75, 0.06), (0.88, 0.12), (0.60, 0.03), (0.42, 0.10)
        ]
        let p = positions[index % positions.count]
        x = bounds.width * p.0
        y = bounds.height * p.1
        size = CGFloat(8 + index * 3)
    }
}
