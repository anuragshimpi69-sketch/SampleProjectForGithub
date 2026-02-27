import SwiftUI

// MARK: - Dashboard View
struct DashboardView: View {
    @State private var currentStress: StressLevel = .low
    @State private var breathCount: Int = 0
    @State private var animateCards = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple.opacity(0.8), Color.calmMidPurple.opacity(0.5)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Greeting
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Good \(greetingTime) 🌿")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("How are you feeling today?")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.calmWhite70)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        // Stress card
                        stressCard
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.calmStagger(index: 0), value: animateCards)

                        // Quick actions
                        HStack(spacing: 14) {
                            quickAction(icon: "wind", title: "Breathe", color: .calmButtonBlueStart)
                            quickAction(icon: "pencil.line", title: "Journal", color: .calmButtonGreenStart)
                            quickAction(icon: "chart.bar.fill", title: "Insights", color: .calmButtonPurpleStart)
                        }
                        .padding(.horizontal, 24)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        .animation(.calmStagger(index: 1), value: animateCards)

                        // Today's tip
                        tipCard
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.calmStagger(index: 2), value: animateCards)

                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear { animateCards = true }
    }

    private var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Morning" }
        else if hour < 17 { return "Afternoon" }
        else { return "Evening" }
    }

    private var stressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Current Stress Level")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Text(currentStress.emoji)
                    .font(.system(size: 28))
            }

            HStack(spacing: 8) {
                ForEach(StressLevel.allCases, id: \.rawValue) { level in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(level == currentStress ? level.color : level.color.opacity(0.3))
                            .frame(height: 6)
                        Text(level.rawValue)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(level == currentStress ? .white : .calmWhite50)
                    }
                }
            }

            Text(currentStress.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.calmWhite70)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }

    private func quickAction(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.calmWhite70)
        }
        .frame(maxWidth: .infinity)
    }

    private var tipCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Today's Tip")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            Text("Take a 5-minute break every hour. Short pauses help reduce cortisol levels and improve focus.")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.calmWhite70)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
}
