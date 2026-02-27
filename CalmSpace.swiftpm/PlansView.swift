import SwiftUI

// MARK: - Plans View (My Meditation Plans)
struct PlansView: View {
    @State private var selectedFilter: String = "All meditation"
    @State private var animateCards = false
    @State private var showSession = false
    @State private var activePlanTitle = ""
    @State private var activePlanDuration = 10

    private let filters = ["All meditation", "Breathing", "Sleep", "Focus"]

    private let plans: [(String, String, String, Int)] = [
        ("We wake up meditation", "10 min · Morning", "meditation_sunrise", 10),
        ("Breathe with the clouds", "15 min · Afternoon", "meditation_clouds", 15),
        ("Monthly stress reflection", "20 min · Evening", "meditation_reflection", 20)
    ]

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

                    Spacer()

                    Image(systemName: "heart")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                // ── Title ──
                Text("My plans")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                // ── Filters ──
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedFilter = filter
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Text(filter)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(
                                            selectedFilter == filter ? .white : .white.opacity(0.7)
                                        )
                                    if selectedFilter == filter {
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            selectedFilter == filter
                                                ? AnyShapeStyle(LinearGradient(colors: [.calmMidPurple, .calmDeepPurple], startPoint: .leading, endPoint: .trailing))
                                                : AnyShapeStyle(Color.white.opacity(0.12))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 16)

                // ── Plan Cards ──
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(Array(plans.enumerated()), id: \.offset) { index, plan in
                            planCard(title: plan.0, subtitle: plan.1, imageName: plan.2, duration: plan.3, index: index)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showSession) {
            MeditationSessionView(title: activePlanTitle, durationMinutes: activePlanDuration)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { animateCards = true }
        }
    }

    private func planCard(title: String, subtitle: String, imageName: String, duration: Int, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                // Text content
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))

                    // Play button — functional!
                    Button(action: {
                        activePlanTitle = title
                        activePlanDuration = duration
                        showSession = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(
                                    Circle()
                                        .fill(LinearGradient(colors: [.calmMidPurple, .calmDeepPurple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                )
                                .shadow(color: Color.calmMidPurple.opacity(0.4), radius: 4)

                            Text("Start")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 2)
                }

                Spacer()

                // Image thumbnail
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.calmMidPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .opacity(animateCards ? 1 : 0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.calmStagger(index: index), value: animateCards)
    }
}
