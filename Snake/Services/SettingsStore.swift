import Combine
import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.sound) }
    }

    @Published var hapticsEnabled: Bool {
        didSet { defaults.set(hapticsEnabled, forKey: Keys.haptics) }
    }

    @Published var gridEnabled: Bool {
        didSet { defaults.set(gridEnabled, forKey: Keys.grid) }
    }

    @Published var difficulty: Difficulty {
        didSet { defaults.set(difficulty.rawValue, forKey: Keys.difficulty) }
    }

    @Published var snakeTheme: SnakeColorTheme {
        didSet { defaults.set(snakeTheme.rawValue, forKey: Keys.snakeTheme) }
    }

    @Published var fruitKind: FruitKind {
        didSet { defaults.set(fruitKind.rawValue, forKey: Keys.fruitKind) }
    }

    private let defaults: UserDefaults

    private enum Keys {
        static let sound = "snake.settings.sound"
        static let haptics = "snake.settings.haptics"
        static let grid = "snake.settings.grid"
        static let difficulty = "snake.settings.difficulty"
        static let snakeTheme = "snake.settings.color"
        static let fruitKind = "snake.settings.fruit"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if defaults.object(forKey: Keys.sound) == nil {
            soundEnabled = true
        } else {
            soundEnabled = defaults.bool(forKey: Keys.sound)
        }
        if defaults.object(forKey: Keys.haptics) == nil {
            hapticsEnabled = true
        } else {
            hapticsEnabled = defaults.bool(forKey: Keys.haptics)
        }
        if defaults.object(forKey: Keys.grid) == nil {
            gridEnabled = true
        } else {
            gridEnabled = defaults.bool(forKey: Keys.grid)
        }
        if let raw = defaults.string(forKey: Keys.difficulty), let value = Difficulty(rawValue: raw) {
            difficulty = value
        } else {
            difficulty = .normal
        }
        if let raw = defaults.string(forKey: Keys.snakeTheme), let value = SnakeColorTheme(rawValue: raw) {
            snakeTheme = value
        } else {
            snakeTheme = .classic
        }
        if let raw = defaults.string(forKey: Keys.fruitKind), let value = FruitKind(rawValue: raw) {
            fruitKind = value
        } else {
            fruitKind = .apple
        }
        if StoreScreenshotLaunch.isActive {
            applyStoreScreenshotDefaults()
        }
    }

    func applyStoreScreenshotDefaults() {
        soundEnabled = false
        hapticsEnabled = false
        gridEnabled = true
        difficulty = .normal
        snakeTheme = .classic
        fruitKind = .apple
    }
}
