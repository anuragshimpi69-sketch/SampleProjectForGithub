import SwiftUI

// MARK: - Main Tab View (Post-Onboarding)
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            BreathingView()
                .tabItem {
                    Image(systemName: "wind")
                    Text("Breathe")
                }
                .tag(1)

            MoodJournalView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
                .tag(2)

            InsightsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Insights")
                }
                .tag(3)
        }
        .tint(.calmLavender)
    }
}
