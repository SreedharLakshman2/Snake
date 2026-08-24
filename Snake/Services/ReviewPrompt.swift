import StoreKit
import UIKit

/// Asks for an App Store rating after real play, using Apple's in-app review dialog.
/// Apple still limits how often the dialog can appear (about three times a year).
@MainActor
enum ReviewPrompt {
    private static let firstUseKey = "snake.firstUse"
    private static let lastPromptKey = "snake.lastReviewPrompt"
    private static let promptCountKey = "snake.reviewPromptCount"
    private static let gamesKey = "snake.lifetimeGamesForReview"
    private static let secondsKey = "snake.foregroundSeconds"
    private static var sessionStart: Date?

    static let minGames = 3
    static let minSecondsOfUse: TimeInterval = 60
    static let minDaysBetweenPrompts = 30
    static let maxPrompts = 3

    static func recordFirstUseIfNeeded() {
        guard UserDefaults.standard.object(forKey: firstUseKey) == nil else { return }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: firstUseKey)
    }

    static func noteBecameActive() {
        recordFirstUseIfNeeded()
        sessionStart = Date()
    }

    static func noteBecameInactive() {
        flushSessionTime()
    }

    static func recordGameFinished() {
        recordFirstUseIfNeeded()
        flushSessionTime()
        sessionStart = Date()
        let total = UserDefaults.standard.integer(forKey: gamesKey) + 1
        UserDefaults.standard.set(total, forKey: gamesKey)
    }

    static func askIfAppropriate(delay: TimeInterval = 1.6) {
        flushSessionTime()
        sessionStart = Date()
        guard isEligible else { return }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            flushSessionTime()
            sessionStart = Date()
            guard isEligible else { return }
            requestReview()
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastPromptKey)
            let count = UserDefaults.standard.integer(forKey: promptCountKey) + 1
            UserDefaults.standard.set(count, forKey: promptCountKey)
        }
    }

    static func requestReview() {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        guard let scene else { return }
        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private static func flushSessionTime() {
        guard let start = sessionStart else { return }
        let added = Date().timeIntervalSince(start)
        sessionStart = nil
        let total = UserDefaults.standard.double(forKey: secondsKey) + max(0, added)
        UserDefaults.standard.set(total, forKey: secondsKey)
    }

    private static var isEligible: Bool {
        recordFirstUseIfNeeded()
        let last = UserDefaults.standard.double(forKey: lastPromptKey)
        guard UserDefaults.standard.integer(forKey: promptCountKey) < maxPrompts else { return false }
        guard UserDefaults.standard.integer(forKey: gamesKey) >= minGames else { return false }
        guard UserDefaults.standard.double(forKey: secondsKey) >= minSecondsOfUse else { return false }
        if last > 0 {
            let days = Date().timeIntervalSince1970 - last
            guard days >= Double(minDaysBetweenPrompts) * 86_400 else { return false }
        }
        return true
    }
}
