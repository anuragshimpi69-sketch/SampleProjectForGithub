import SwiftUI

// MARK: - Meditation Session View
struct MeditationSessionView: View {
    let title: String
    let durationMinutes: Int
    @Environment(\.dismiss) private var dismiss

    @State private var isRunning = false
    @State private var isPaused = false
    @State private var secondsRemaining: Int
    @State private var circleScale: CGFloat = 0.5
    @State private var circleOpacity: Double = 0.6
    @State private var breathPhase: String = "Tap Start to Begin"
    @State private var timer: Timer?
    @State private var sessionComplete = false

    init(title: String, durationMinutes: Int) {
        self.title = title
        self.durationMinutes = durationMinutes
        _secondsRemaining = State(initialValue: durationMinutes * 60)
    }

    private var timeString: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return String(format: "%02d:%02d", m, s)
    }

    private var progress: Double {
        let total = Double(durationMinutes * 60)
        return 1.0 - (Double(secondsRemaining) / total)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple.opacity(0.8), Color.calmMidPurple.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Title
                    VStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("\(durationMinutes) min session")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 20)

                    Spacer()

                    // Breathing circle + timer
                    ZStack {
                        // Progress ring background
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 6)
                            .frame(width: 240, height: 240)

                        // Progress ring
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(
                                    colors: [.calmMidPurple, .calmLavender, .calmButtonBlueStart],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 240, height: 240)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)

                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.calmLavender.opacity(circleOpacity * 0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 40,
                                    endRadius: 130
                                )
                            )
                            .frame(width: 260, height: 260)
                            .scaleEffect(circleScale * 1.2)

                        // Main breathing circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.calmMidPurple.opacity(circleOpacity),
                                        Color.calmDeepPurple.opacity(circleOpacity * 0.5)
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(circleScale)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.25), lineWidth: 2)
                                    .scaleEffect(circleScale)
                            )

                        // Timer text
                        VStack(spacing: 6) {
                            Text(timeString)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                            Text(breathPhase)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }

                    Spacer()

                    // Controls
                    if sessionComplete {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)

                            Text("Session Complete!")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Button(action: { dismiss() }) {
                                Text("Done")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 28)
                                            .fill(LinearGradient.calmCTA)
                                    )
                            }
                            .padding(.horizontal, 40)
                        }
                    } else {
                        HStack(spacing: 20) {
                            // End button
                            Button(action: endSession) {
                                Text("End")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(width: 80, height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 28)
                                            .fill(Color.white.opacity(0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 28)
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }

                            // Start / Pause button
                            Button(action: toggleSession) {
                                Text(isRunning ? (isPaused ? "Resume" : "Pause") : "Start")
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
                        }
                        .padding(.horizontal, 30)
                    }

                    Spacer().frame(height: 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { endSession() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func toggleSession() {
        if !isRunning {
            // First start
            isRunning = true
            isPaused = false
            startTimer()
            startBreathing()
        } else if isPaused {
            // Resume
            isPaused = false
            startTimer()
            startBreathing()
        } else {
            // Pause
            isPaused = true
            timer?.invalidate()
            breathPhase = "Paused"
            withAnimation(.easeInOut(duration: 0.5)) {
                circleScale = 0.6
                circleOpacity = 0.5
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            Task { @MainActor in
                if secondsRemaining > 0 {
                    secondsRemaining -= 1
                } else {
                    timer?.invalidate()
                    sessionComplete = true
                    breathPhase = "Complete"
                }
            }
        }
    }

    private func startBreathing() {
        guard isRunning, !isPaused else { return }
        runBreathCycle()
    }

    private func runBreathCycle() {
        guard isRunning, !isPaused, !sessionComplete else { return }

        breathPhase = "Breathe In..."
        withAnimation(.easeInOut(duration: 4.0)) {
            circleScale = 1.0
            circleOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            guard self.isRunning, !self.isPaused, !self.sessionComplete else { return }
            self.breathPhase = "Hold..."

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                guard self.isRunning, !self.isPaused, !self.sessionComplete else { return }
                self.breathPhase = "Breathe Out..."
                withAnimation(.easeInOut(duration: 6.0)) {
                    self.circleScale = 0.5
                    self.circleOpacity = 0.6
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.runBreathCycle()
                }
            }
        }
    }

    private func endSession() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        dismiss()
    }
}
