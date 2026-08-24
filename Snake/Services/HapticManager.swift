import Foundation
import UIKit

@MainActor
final class HapticManager {
    static let shared = HapticManager()

    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let soft = UIImpactFeedbackGenerator(style: .soft)
    private let notify = UINotificationFeedbackGenerator()

    private init() {
        light.prepare()
        medium.prepare()
        soft.prepare()
        notify.prepare()
    }

    func buttonPress(enabled: Bool) {
        guard enabled else { return }
        light.impactOccurred()
        light.prepare()
    }

    func directionChanged(enabled: Bool) {
        guard enabled else { return }
        soft.impactOccurred()
        soft.prepare()
    }

    func eat(enabled: Bool) {
        guard enabled else { return }
        medium.impactOccurred()
        medium.prepare()
    }

    func gameOver(enabled: Bool) {
        guard enabled else { return }
        notify.notificationOccurred(.error)
        notify.prepare()
    }
}
