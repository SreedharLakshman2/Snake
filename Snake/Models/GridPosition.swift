import Foundation

struct GridPosition: Equatable, Hashable {
    var x: Int
    var y: Int

    func moved(in direction: SnakeDirection) -> GridPosition {
        GridPosition(x: x + direction.deltaX, y: y + direction.deltaY)
    }

    func isInside(columns: Int, rows: Int) -> Bool {
        x >= 0 && y >= 0 && x < columns && y < rows
    }
}
