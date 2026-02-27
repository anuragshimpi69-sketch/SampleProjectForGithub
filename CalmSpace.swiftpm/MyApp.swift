import SwiftUI

@main
struct CalmSpaceApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .preferredColorScheme(.dark)
            } else {
                WelcomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
