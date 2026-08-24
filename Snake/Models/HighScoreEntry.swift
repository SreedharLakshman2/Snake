import Foundation

struct HighScoreEntry: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    let score: Int
    let date: Date

    init(id: UUID = UUID(), name: String, score: Int, date: Date = Date()) {
        self.id = id
        self.name = name
        self.score = score
        self.date = date
    }
}
