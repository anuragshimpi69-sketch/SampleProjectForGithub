import SwiftUI

// MARK: - Welcome / Onboarding View
struct WelcomeView: View {
    @Binding var hasCompletedOnboarding: Bool

    @State private var headerAppeared = false
    @State private var illustrationAppeared = false
    @State private var glowPulse = false

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.height < 700

            ZStack {
                // ── Background gradient ──
                LinearGradient.calmBackground
                    .ignoresSafeArea()

                // ── Stars + Moon ──
                StarFieldView(starCount: 25)
                    .ignoresSafeArea()

                // ── Mountain landscape ──
                MountainBackgroundView()
                    .ignoresSafeArea()
                    .opacity(0.8)

                // ── Content ──
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: isCompact ? 14 : 20) {

                        Spacer().frame(height: isCompact ? 10 : 20)

                        // ── App Icon ──
                        AppIconView(size: isCompact ? 60 : 70)
                            .opacity(headerAppeared ? 1 : 0)
                            .scaleEffect(headerAppeared ? 1 : 0.6)
                            .animation(.calmEntrance, value: headerAppeared)

                        // ── Title ──
                        Text("CalmSpace")
                            .font(.system(size: isCompact ? 32 : 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(headerAppeared ? 1 : 0)
                            .offset(y: headerAppeared ? 0 : 15)
                            .animation(.calmStagger(index: 1), value: headerAppeared)

                        // ── Subtitle ──
                        Text("Your pocket calm, anytime stress hits.")
                            .font(.system(size: isCompact ? 15 : 17, weight: .regular, design: .rounded))
                            .foregroundColor(.calmWhite70)
                            .multilineTextAlignment(.center)
                            .opacity(headerAppeared ? 1 : 0)
                            .offset(y: headerAppeared ? 0 : 10)
                            .animation(.calmStagger(index: 2), value: headerAppeared)

                        // ── Meditation Illustration ──
                        ZStack {
                            // Soft glow behind illustration
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.calmLavender.opacity(glowPulse ? 0.35 : 0.15),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: isCompact ? 100 : 130
                                    )
                                )
                                .frame(width: isCompact ? 220 : 280, height: isCompact ? 220 : 280)
                                .animation(.calmGlow, value: glowPulse)

                            Image("meditation_woman")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: isCompact ? 200 : 250, height: isCompact ? 200 : 250)
                        }
                        .opacity(illustrationAppeared ? 1 : 0)
                        .scaleEffect(illustrationAppeared ? 1 : 0.8)
                        .animation(.calmStagger(index: 2), value: illustrationAppeared)

                        // ── Feature Buttons ──
                        VStack(spacing: isCompact ? 10 : 14) {
                            GlassButton(
                                icon: "face.smiling",
                                text: "AI Stress Detection",
                                gradient: .calmPurpleButton,
                                index: 0
                            )

                            GlassButton(
                                icon: "wind",
                                text: "Guided Breathing Exercises",
                                gradient: .calmBlueButton,
                                index: 1
                            )

                            GlassButton(
                                icon: "book.fill",
                                text: "Mood & Progress Tracker",
                                gradient: .calmGreenButton,
                                index: 2
                            )
                        }
                        .padding(.horizontal, 28)

                        Spacer().frame(height: isCompact ? 8 : 16)

                        // ── Get Started CTA ──
                        GetStartedButton {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                hasCompletedOnboarding = true
                            }
                        }
                        .padding(.horizontal, 40)

                        // ── Footer ──
                        Text("100% Private & On-Device")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.calmWhite50)
                            .padding(.top, 6)
                            .padding(.bottom, isCompact ? 16 : 24)
                    }
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                headerAppeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                illustrationAppeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                glowPulse = true
            }
        }
    }
}
