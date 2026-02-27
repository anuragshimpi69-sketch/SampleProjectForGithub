import SwiftUI

// MARK: - Breathing View
struct BreathingView: View {
    @State private var isBreathing = false
    @State private var breathPhase: BreathPhase = .ready
    @State private var circleScale: CGFloat = 0.5
    @State private var circleOpacity: Double = 0.6
    @State private var timer: Timer?
    @State private var secondsRemaining = 0

    enum BreathPhase: String {
        case ready = "Tap to Begin"
        case breatheIn = "Breathe In..."
        case hold = "Hold..."
        case breatheOut = "Breathe Out..."
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple.opacity(0.7), Color.calmMidPurple.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Text("Guided Breathing")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Spacer()

                    // Breathing circle
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.calmLavender.opacity(circleOpacity * 0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 60,
                                    endRadius: 160
                                )
                            )
                            .frame(width: 300, height: 300)
                            .scaleEffect(circleScale * 1.3)

                        // Main circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.calmMidPurple.opacity(circleOpacity),
                                        Color.calmDeepPurple.opacity(circleOpacity * 0.5)
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .scaleEffect(circleScale)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    .scaleEffect(circleScale)
                            )

                        // Phase text
                        Text(breathPhase.rawValue)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Control button
                    Button(action: toggleBreathing) {
                        Text(isBreathing ? "Stop" : "Start Breathing")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(LinearGradient.calmCTA)
                            )
                            .shadow(color: Color.calmDeepPurple.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
                .padding(.top, 20)
            }
            .navigationBarHidden(true)
        }
    }

    private func toggleBreathing() {
        if isBreathing {
            stopBreathing()
        } else {
            startBreathing()
        }
    }

    private func startBreathing() {
        isBreathing = true
        runCycle()
    }

    private func stopBreathing() {
        isBreathing = false
        timer?.invalidate()
        timer = nil
        breathPhase = .ready
        withAnimation(.easeInOut(duration: 0.5)) {
            circleScale = 0.5
            circleOpacity = 0.6
        }
    }

    private func runCycle() {
        guard isBreathing else { return }

        // Breathe In (4 seconds)
        breathPhase = .breatheIn
        withAnimation(.easeInOut(duration: 4.0)) {
            circleScale = 1.0
            circleOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            guard self.isBreathing else { return }
            // Hold (4 seconds)
            self.breathPhase = .hold

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                guard self.isBreathing else { return }
                // Breathe Out (6 seconds)
                self.breathPhase = .breatheOut
                withAnimation(.easeInOut(duration: 6.0)) {
                    self.circleScale = 0.5
                    self.circleOpacity = 0.6
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.runCycle()
                }
            }
        }
    }
}
