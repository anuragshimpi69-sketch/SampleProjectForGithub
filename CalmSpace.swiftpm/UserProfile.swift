import Foundation

// MARK: - User Profile Model
struct UserProfile: Codable, Sendable {
    var name: String
    var hasCompletedOnboarding: Bool
    var totalSessions: Int
    var streakDays: Int
    var joinDate: Date

    init(
        name: String = "",
        hasCompletedOnboarding: Bool = false,
        totalSessions: Int = 0,
        streakDays: Int = 0,
        joinDate: Date = Date()
    ) {
        self.name = name
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.totalSessions = totalSessions
        self.streakDays = streakDays
        self.joinDate = joinDate
    }
}
