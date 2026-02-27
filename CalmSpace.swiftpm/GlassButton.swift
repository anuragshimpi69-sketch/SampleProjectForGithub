import SwiftUI

// MARK: - Glassmorphism Feature Button
struct GlassButton: View {
    let icon: String
    let text: String
    let gradient: LinearGradient
    let index: Int

    @State private var appeared = false

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                )

            // Text
            Text(text)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // Gradient fill
                RoundedRectangle(cornerRadius: 30)
                    .fill(gradient)
                    .opacity(0.7)

                // Glass overlay
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Subtle border
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            }
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.calmStagger(index: index), value: appeared)
        .onAppear { appeared = true }
    }
}

// MARK: - "Get Started" CTA Button
struct GetStartedButton: View {
    let action: () -> Void
    @State private var appeared = false
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text("Get Started")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(LinearGradient.calmCTA)

                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    }
                )
                .shadow(color: Color.calmDeepPurple.opacity(0.5), radius: 16, x: 0, y: 8)
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = false } }
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 30)
        .animation(.calmStagger(index: 4), value: appeared)
        .onAppear { appeared = true }
    }
}
