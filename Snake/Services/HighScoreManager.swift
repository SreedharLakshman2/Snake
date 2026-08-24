import Foundation

final class HighScoreManager {
    static let shared = HighScoreManager()

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let best = "snake.bestScore"
        static let list = "snake.topScores"
        static let lastRun = "snake.lastSubmittedScoreID"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var playerName: String {
        GameConfig.defaultPlayerName
    }

    func loadBest() -> Int {
        defaults.integer(forKey: Keys.best)
    }

    func saveBest(_ score: Int) {
        defaults.set(score, forKey: Keys.best)
    }

    @discardableResult
    func updateBest(with score: Int) -> Int {
        let best = max(loadBest(), score)
        saveBest(best)
        return best
    }

    func loadTopScores() -> [HighScoreEntry] {
        guard let data = defaults.data(forKey: Keys.list) else { return [] }
        return (try? decoder.decode([HighScoreEntry].self, from: data)) ?? []
    }

    func lastSubmittedID() -> UUID? {
        guard let raw = defaults.string(forKey: Keys.lastRun) else { return nil }
        return UUID(uuidString: raw)
    }

    @discardableResult
    func submit(score: Int, name: String? = nil) -> HighScoreEntry? {
        guard score > 0 else { return nil }
        let entry = HighScoreEntry(name: name ?? playerName, score: score)
        var scores = loadTopScores()
        scores.append(entry)
        scores.sort { lhs, rhs in
            if lhs.score == rhs.score {
                return lhs.date > rhs.date
            }
            return lhs.score > rhs.score
        }
        if scores.count > GameConfig.maxHighScores {
            scores = Array(scores.prefix(GameConfig.maxHighScores))
        }
        if let data = try? encoder.encode(scores) {
            defaults.set(data, forKey: Keys.list)
        }
        updateBest(with: score)
        defaults.set(entry.id.uuidString, forKey: Keys.lastRun)
        return entry
    }
}
