import SwiftUI

// MARK: - App Color Palette
extension Color {
    // Primary palette
    static let calmDeepPurple = Color(red: 0.357, green: 0.294, blue: 1.0)       // #5B4BFF
    static let calmMidPurple = Color(red: 0.494, green: 0.384, blue: 0.976)       // #7E62F9
    static let calmLavender = Color(red: 0.690, green: 0.612, blue: 0.980)        // #B09CFA
    static let calmSoftLavender = Color(red: 0.796, green: 0.745, blue: 0.988)    // #CBBEFB
    static let calmLightPink = Color(red: 0.910, green: 0.776, blue: 0.882)       // #E8C6E1
    static let calmPeach = Color(red: 0.949, green: 0.820, blue: 0.820)           // #F2D1D1

    // Button gradients
    static let calmButtonPurpleStart = Color(red: 0.706, green: 0.612, blue: 1.0) // #B49CFF
    static let calmButtonPurpleEnd = Color(red: 0.545, green: 0.455, blue: 0.937) // #8B74EF
    static let calmButtonBlueStart = Color(red: 0.506, green: 0.702, blue: 1.0)   // #81B3FF
    static let calmButtonBlueEnd = Color(red: 0.337, green: 0.537, blue: 0.937)   // #5689EF
    static let calmButtonGreenStart = Color(red: 0.506, green: 0.882, blue: 0.757) // #81E1C1
    static let calmButtonGreenEnd = Color(red: 0.337, green: 0.729, blue: 0.620)  // #56BA9E

    // CTA
    static let calmCTAPurple = Color(red: 0.490, green: 0.380, blue: 0.980)      // #7D61FA
    static let calmCTABlue = Color(red: 0.369, green: 0.639, blue: 1.0)          // #5EA3FF

    // Sky / Background
    static let calmNightSky = Color(red: 0.216, green: 0.157, blue: 0.502)       // #372880
    static let calmDuskPurple = Color(red: 0.357, green: 0.271, blue: 0.651)     // #5B45A6
    static let calmMountainPurple = Color(red: 0.408, green: 0.329, blue: 0.620) // #68549E

    // Text
    static let calmWhite = Color.white
    static let calmWhite70 = Color.white.opacity(0.7)
    static let calmWhite50 = Color.white.opacity(0.5)
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let calmBackground = LinearGradient(
        colors: [
            Color.calmNightSky,
            Color.calmDeepPurple,
            Color.calmMidPurple,
            Color.calmLavender,
            Color.calmSoftLavender,
            Color.calmLightPink
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let calmCTA = LinearGradient(
        colors: [Color.calmCTAPurple, Color.calmCTABlue],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let calmPurpleButton = LinearGradient(
        colors: [Color.calmButtonPurpleStart, Color.calmButtonPurpleEnd],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let calmBlueButton = LinearGradient(
        colors: [Color.calmButtonBlueStart, Color.calmButtonBlueEnd],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let calmGreenButton = LinearGradient(
        colors: [Color.calmButtonGreenStart, Color.calmButtonGreenEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
}
