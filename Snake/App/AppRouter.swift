import Combine
import Foundation

enum AppScreen: Equatable {
    case splash
    case menu
    case game
    case highScore
    case settings
    case about
}

@MainActor
final class AppRouter: ObservableObject {
    @Published var screen: AppScreen = .splash

    func showMenu() {
        screen = .menu
    }

    func play() {
        screen = .game
    }

    func showHighScore() {
        screen = .highScore
    }

    func showSettings() {
        screen = .settings
    }

    func showAbout() {
        screen = .about
    }
}
