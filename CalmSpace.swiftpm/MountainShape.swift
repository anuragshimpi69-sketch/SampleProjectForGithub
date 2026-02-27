import SwiftUI

// MARK: - Mountain Silhouette Background
struct MountainBackgroundView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Far mountains (lighter, more blurred)
                MountainLayer(
                    peaks: [0.0, 0.35, 0.55, 0.75, 1.0],
                    heights: [0.55, 0.35, 0.28, 0.38, 0.55],
                    color: Color.calmMountainPurple.opacity(0.4)
                )
                .blur(radius: 6)
                .offset(y: geo.size.height * 0.30)

                // Mid mountains
                MountainLayer(
                    peaks: [0.0, 0.20, 0.45, 0.65, 0.85, 1.0],
                    heights: [0.50, 0.38, 0.30, 0.25, 0.35, 0.50],
                    color: Color.calmDuskPurple.opacity(0.5)
                )
                .blur(radius: 3)
                .offset(y: geo.size.height * 0.34)

                // Near mountains (darker, sharper)
                MountainLayer(
                    peaks: [0.0, 0.15, 0.30, 0.50, 0.70, 0.90, 1.0],
                    heights: [0.45, 0.35, 0.42, 0.28, 0.40, 0.33, 0.45],
                    color: Color.calmNightSky.opacity(0.45)
                )
                .blur(radius: 1)
                .offset(y: geo.size.height * 0.38)

                // Water / Reflection
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.calmMidPurple.opacity(0.3),
                                Color.calmLavender.opacity(0.15),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: geo.size.height * 0.12)
                    .offset(y: geo.size.height * 0.44)
            }
        }
    }
}

// MARK: - Mountain Layer Shape
struct MountainLayer: View {
    let peaks: [CGFloat]     // x positions (0...1)
    let heights: [CGFloat]   // y heights (0...1, lower = taller)
    let color: Color

    var body: some View {
        GeometryReader { geo in
            MountainShape(peaks: peaks, heights: heights)
                .fill(color)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct MountainShape: Shape {
    let peaks: [CGFloat]
    let heights: [CGFloat]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard peaks.count == heights.count, peaks.count >= 2 else { return path }

        path.move(to: CGPoint(x: 0, y: rect.height))

        // First point
        let firstPoint = CGPoint(x: peaks[0] * rect.width, y: heights[0] * rect.height)
        path.addLine(to: firstPoint)

        // Smooth curve through peaks
        for i in 1..<peaks.count {
            let point = CGPoint(x: peaks[i] * rect.width, y: heights[i] * rect.height)
            let prevPoint = CGPoint(x: peaks[i-1] * rect.width, y: heights[i-1] * rect.height)
            let midX = (prevPoint.x + point.x) / 2

            path.addCurve(
                to: point,
                control1: CGPoint(x: midX, y: prevPoint.y),
                control2: CGPoint(x: midX, y: point.y)
            )
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()

        return path
    }
}
