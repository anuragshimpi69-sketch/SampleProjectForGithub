import SwiftUI

// MARK: - Dashboard View (Redesigned — Mood Gauge)
struct DashboardView: View {
    @AppStorage("userName") private var userName: String = ""
    @State private var currentMoodAngle: Double = -30  // degrees on the gauge
    @State private var moodLabel: String = "Neutral"
    @State private var animateIn = false
    @State private var pulseGlow = false
    @State private var showEmotionSheet = false

    private let moodOptions: [(String, Double, Color)] = [
        ("Sad", -120, .blue),
        ("Anxious", -80, .purple),
        ("Neutral", -30, .calmLavender),
        ("Calm", 30, .green),
        ("Happy", 80, .yellow)
    ]

    private var greeting: String {
        userName.isEmpty ? "Hello!" : "Hello, \(userName)!"
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.calmNightSky,
                    Color.calmDeepPurple.opacity(0.8),
                    Color.calmMidPurple.opacity(0.5),
                    Color.calmDeepPurple.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Top Bar ──
                HStack {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.calmMidPurple, .calmDeepPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            )

                        Text(greeting)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                // ── Title ──
                Text("How do you\nfeel today?")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 15)
                    .animation(.calmStagger(index: 0), value: animateIn)

                Spacer()

                // ── Mood Gauge ──
                ZStack {
                    // Outer ring glow
                    Circle()
                        .stroke(Color.white.opacity(pulseGlow ? 0.35 : 0.2), lineWidth: 2)
                        .frame(width: 260, height: 260)
                        .shadow(color: Color.calmLavender.opacity(pulseGlow ? 0.5 : 0.15), radius: 20)
                        .animation(.calmGlow, value: pulseGlow)

                    // Inner ring
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .frame(width: 200, height: 200)

                    // Gauge arc
                    GaugeArc(startAngle: -150, endAngle: currentMoodAngle - 90)
                        .stroke(
                            AngularGradient(
                                colors: [.blue, .purple, .calmLavender, .green, .yellow],
                                center: .center,
                                startAngle: .degrees(-150),
                                endAngle: .degrees(150)
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 220, height: 220)
                        .animation(.easeInOut(duration: 0.8), value: currentMoodAngle)

                    // Mood indicator dot
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .shadow(color: .white.opacity(0.6), radius: 8)
                        .offset(x: 110 * cos(CGFloat((currentMoodAngle - 90) * .pi / 180)),
                                y: 110 * sin(CGFloat((currentMoodAngle - 90) * .pi / 180)))
                        .animation(.easeInOut(duration: 0.8), value: currentMoodAngle)

                    // Small dots around the circle
                    ForEach(0..<12, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 5, height: 5)
                            .offset(x: 130 * cos(CGFloat(Double(i) * 30 - 90) * .pi / 180),
                                    y: 130 * sin(CGFloat(Double(i) * 30 - 90) * .pi / 180))
                    }

                    // Center label
                    VStack(spacing: 4) {
                        Text(moodLabel)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .opacity(animateIn ? 1 : 0)
                .scaleEffect(animateIn ? 1 : 0.7)
                .animation(.calmStagger(index: 1), value: animateIn)

                Spacer()

                // ── Mood Selector ──
                HStack(spacing: 14) {
                    ForEach(moodOptions, id: \.0) { mood, angle, color in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                currentMoodAngle = angle
                                moodLabel = mood
                            }
                        }) {
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(moodLabel == mood ? color : color.opacity(0.4))
                                    .frame(width: 12, height: 12)
                                    .shadow(color: moodLabel == mood ? color.opacity(0.6) : .clear, radius: 4)
                                Text(mood)
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundColor(moodLabel == mood ? .white : .white.opacity(0.5))
                            }
                        }
                    }
                }
                .padding(.bottom, 12)

                // ── Action Buttons ──
                HStack(spacing: 14) {
                    Button(action: { showEmotionSheet = true }) {
                        actionButtonContent(icon: "heart.text.square", text: "Add your\nemotion")
                    }

                    Button(action: { /* placeholder */ }) {
                        actionButtonContent(icon: "calendar.badge.clock", text: "Make an\nappointment")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 20)
                .animation(.calmStagger(index: 3), value: animateIn)
            }
        }
        .sheet(isPresented: $showEmotionSheet) {
            EmotionQuickSheet(moodOptions: moodOptions) { mood, angle in
                withAnimation(.easeInOut(duration: 0.6)) {
                    currentMoodAngle = angle
                    moodLabel = mood
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { animateIn = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { pulseGlow = true }
        }
    }

    private func actionButtonContent(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))

            Text(text)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
    }
}

// MARK: - Emotion Quick Sheet
struct EmotionQuickSheet: View {
    let moodOptions: [(String, Double, Color)]
    let onSelect: (String, Double) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("How are you feeling?")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 30)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(moodOptions, id: \.0) { mood, angle, color in
                            Button(action: {
                                onSelect(mood, angle)
                                dismiss()
                            }) {
                                VStack(spacing: 10) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 44, height: 44)
                                        .shadow(color: color.opacity(0.5), radius: 6)
                                    Text(mood)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.calmLavender)
                }
            }
        }
    }
}

// MARK: - Gauge Arc Shape
struct GaugeArc: Shape {
    var startAngle: Double
    var endAngle: Double

    var animatableData: Double {
        get { endAngle }
        set { endAngle = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        var path = Path()
        path.addArc(center: center, radius: radius,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false)
        return path
    }
}
