import SwiftUI

// MARK: - Insights View
struct InsightsView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.calmNightSky, Color.calmDeepPurple.opacity(0.7), Color.calmMidPurple.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        Text("Weekly Insights")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)

                        // Empty state
                        emptyState

                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)

            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 56))
                .foregroundColor(.calmWhite50)

            Text("No Insights Yet")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Start logging your mood in the Journal tab.\nYour weekly stress patterns and stats will appear here.")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.calmWhite70)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)

            Spacer().frame(height: 20)
        }
    }
}
