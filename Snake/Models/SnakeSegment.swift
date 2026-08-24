import Foundation

/// A single occupied cell of the snake. The engine stores the body as
/// head-first `GridPosition` values; this type exists so rendering code can
/// talk about segments without leaking game-loop details.
struct SnakeSegment: Equatable, Hashable, Identifiable {
    var position: GridPosition
    var isHead: Bool
    var isTail: Bool

    var id: Int {
        position.x &* 1_000 &+ position.y
    }
}
