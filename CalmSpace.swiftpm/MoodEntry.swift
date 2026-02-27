import SwiftUI

// MARK: - Mood Entry Model
struct MoodEntry: Identifiable, Codable, Sendable {
    let id: UUID
    let date: Date
    let mood: MoodType
    let stressLevel: StressLevel
    let note: String

    init(id: UUID = UUID(), date: Date = Date(), mood: MoodType, stressLevel: StressLevel, note: String = "") {
        self.id = id
        self.date = date
        self.mood = mood
        self.stressLevel = stressLevel
        self.note = note
    }
}

enum MoodType: String, CaseIterable, Codable, Sendable {
    case happy = "Happy"
    case calm = "Calm"
    case neutral = "Neutral"
    case anxious = "Anxious"
    case sad = "Sad"
    case stressed = "Stressed"

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .neutral: return "😐"
        case .anxious: return "😟"
        case .sad: return "😢"
        case .stressed: return "😰"
        }
    }

    var color: Color {
        switch self {
        case .happy: return .yellow
        case .calm: return .green
        case .neutral: return .gray
        case .anxious: return .orange
        case .sad: return .blue
        case .stressed: return .red
        }
    }
}
