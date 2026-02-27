import SwiftUI

// MARK: - Stress Level Model
enum StressLevel: String, CaseIterable, Codable, Sendable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }

    var emoji: String {
        switch self {
        case .low: return "😌"
        case .medium: return "😐"
        case .high: return "😰"
        }
    }

    var description: String {
        switch self {
        case .low: return "You're feeling calm and relaxed"
        case .medium: return "You seem a little tense"
        case .high: return "Take a moment to breathe"
        }
    }
}
