import SwiftUI

// MARK: - Custom Animation Curves
extension Animation {
    static let calmEntrance = Animation.spring(response: 0.8, dampingFraction: 0.75, blendDuration: 0.5)
    static let calmSlow = Animation.easeInOut(duration: 1.2)
    static let calmBreathing = Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true)
    static let calmTwinkle = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    static let calmGlow = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    static let calmFloat = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)

    static func calmStagger(index: Int) -> Animation {
        Animation.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.4)
            .delay(Double(index) * 0.15)
    }
}

// MARK: - View Transition Helpers
extension AnyTransition {
    @MainActor static let calmSlideUp = AnyTransition
        .move(edge: .bottom)
        .combined(with: .opacity)

    @MainActor static let calmFadeScale = AnyTransition
        .scale(scale: 0.8)
        .combined(with: .opacity)
}
