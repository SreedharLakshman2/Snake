import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy
    case normal
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: return "Easy"
        case .normal: return "Normal"
        case .hard: return "Hard"
        }
    }

    /// Seconds between grid steps at the start of a run.
    var baseInterval: TimeInterval {
        switch self {
        case .easy: return 0.22
        case .normal: return 0.155
        case .hard: return 0.11
        }
    }

    /// Interval reduction applied after every piece of food.
    var acceleration: TimeInterval {
        switch self {
        case .easy: return 0.004
        case .normal: return 0.006
        case .hard: return 0.008
        }
    }

    var minimumInterval: TimeInterval {
        switch self {
        case .easy: return 0.10
        case .normal: return 0.065
        case .hard: return 0.045
        }
    }
}
