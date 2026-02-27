import SwiftUI

// MARK: - Main Tab View (Post-Onboarding)
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "leaf.fill" : "leaf")
                    Text("Home")
                }
                .tag(0)

            PlansView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "flame.fill" : "flame")
                    Text("Plans")
                }
                .tag(1)

            BreathingView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "wind" : "wind")
                    Text("Breathe")
                }
                .tag(2)

            MoodJournalView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "book.fill" : "book")
                    Text("Journal")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .tint(.calmMidPurple)
    }
}
