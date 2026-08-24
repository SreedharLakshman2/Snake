import Combine
import Foundation
import SwiftUI
import UIKit

@MainActor
final class SnakeGameViewModel: ObservableObject {
    @Published private(set) var state: GameState = .ready
    @Published private(set) var snake: [GridPosition] = []
    @Published private(set) var food: GridPosition = GridPosition(x: 0, y: 0)
    @Published private(set) var direction: SnakeDirection = .right
    @Published private(set) var score: Int = 0
    @Published private(set) var bestScore: Int = 0
    @Published private(set) var didWin = false
    @Published private(set) var eatPulse = 0
    @Published private(set) var scorePulse = 0
    @Published private(set) var lastEatenFood: GridPosition?

    let columns = GameConfig.columns
    let rows = GameConfig.rows

    private let settings: SettingsStore
    private let highScores: HighScoreManager
    private let haptics = HapticManager.shared
    private let sound = SoundManager.shared

    /// Buffered until the next tick. Reverse of the *committed* heading is ignored.
    private var pendingDirection: SnakeDirection?
    private var moveInterval: TimeInterval = Difficulty.normal.baseInterval
    private var loopCancellable: AnyCancellable?
    private var lastFrame: Date?
    private var accumulator: TimeInterval = 0

    var isLoopRunning: Bool { loopCancellable != nil }

    var segments: [SnakeSegment] {
        guard !snake.isEmpty else { return [] }
        return snake.enumerated().map { index, position in
            SnakeSegment(
                position: position,
                isHead: index == 0,
                isTail: index == snake.count - 1
            )
        }
    }

    var occupiedCells: Set<GridPosition> {
        Set(snake)
    }

    init(settings: SettingsStore, highScores: HighScoreManager) {
        self.settings = settings
        self.highScores = highScores
        bestScore = highScores.loadBest()
        resetBoard(spawnFood: true)
    }

    // MARK: - Lifecycle

    func startGame() {
        resetBoard(spawnFood: true)
        score = 0
        didWin = false
        lastEatenFood = nil
        eatPulse = 0
        scorePulse = 0
        pendingDirection = nil
        moveInterval = settings.difficulty.baseInterval
        bestScore = highScores.loadBest()
        state = .playing
        startLoop()
    }

    func pauseGame() {
        guard state == .playing else { return }
        state = .paused
        stopLoop()
    }

    func resumeGame() {
        guard state == .paused else { return }
        state = .playing
        startLoop()
    }

    func restartGame() {
        startGame()
    }

    func gameOver(won: Bool = false) {
        guard state == .playing else { return }
        didWin = won
        state = .gameOver
        stopLoop()
        highScores.submit(score: score)
        bestScore = highScores.loadBest()
        if won {
            sound.playWin(enabled: settings.soundEnabled)
        } else {
            sound.playGameOver(enabled: settings.soundEnabled)
        }
        haptics.gameOver(enabled: settings.hapticsEnabled)
    }

    func stopLoop() {
        loopCancellable?.cancel()
        loopCancellable = nil
        lastFrame = nil
        accumulator = 0
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func handleScenePhase(_ phase: ScenePhase) {
        if StoreScreenshotLaunch.isActive { return }
        if phase != .active {
            pauseGame()
        }
    }

    /// Frozen mid-run for App Store posters. Chrome stays visible; the loop does not tick.
    func prepareStoreScreenshot() {
        stopLoop()
        direction = .right
        pendingDirection = nil
        score = 120
        bestScore = 240
        didWin = false
        lastEatenFood = nil
        eatPulse = 0
        scorePulse = 0
        snake = [
            GridPosition(x: 15, y: 7),
            GridPosition(x: 14, y: 7),
            GridPosition(x: 13, y: 7),
            GridPosition(x: 12, y: 7),
            GridPosition(x: 11, y: 7),
            GridPosition(x: 10, y: 7),
            GridPosition(x: 9, y: 7),
            GridPosition(x: 8, y: 7),
            GridPosition(x: 8, y: 8),
            GridPosition(x: 8, y: 9),
            GridPosition(x: 8, y: 10),
            GridPosition(x: 9, y: 10),
            GridPosition(x: 10, y: 10),
            GridPosition(x: 11, y: 10),
            GridPosition(x: 12, y: 10),
            GridPosition(x: 13, y: 10),
            GridPosition(x: 14, y: 10),
            GridPosition(x: 15, y: 10),
            GridPosition(x: 16, y: 10),
            GridPosition(x: 16, y: 11),
            GridPosition(x: 16, y: 12),
            GridPosition(x: 16, y: 13),
            GridPosition(x: 15, y: 13),
            GridPosition(x: 14, y: 13),
            GridPosition(x: 13, y: 13),
            GridPosition(x: 12, y: 13),
            GridPosition(x: 11, y: 13),
            GridPosition(x: 10, y: 13),
            GridPosition(x: 9, y: 13),
            GridPosition(x: 8, y: 13)
        ]
        food = GridPosition(x: 17, y: 7)
        state = .playing
    }

    // MARK: - Input

    func changeDirection(_ newDirection: SnakeDirection) {
        guard state == .playing else { return }
        // Compare against the committed heading, not a buffered turn, so a
        // quick Up-then-Left while moving right cannot become an instant 180.
        guard newDirection != direction.opposite else { return }
        pendingDirection = newDirection
        haptics.directionChanged(enabled: settings.hapticsEnabled)
    }

    // MARK: - Loop

    private func startLoop() {
        stopLoop()
        lastFrame = Date()
        accumulator = 0
        UIApplication.shared.isIdleTimerDisabled = true
        loopCancellable = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                self?.tick(now: now)
            }
    }

    private func tick(now: Date) {
        guard state == .playing else { return }
        let previous = lastFrame ?? now
        lastFrame = now
        accumulator += now.timeIntervalSince(previous)

        // Cap catch-up so a long hitch does not skip the snake across the board.
        if accumulator > moveInterval * 3 {
            accumulator = moveInterval
        }

        while accumulator >= moveInterval {
            accumulator -= moveInterval
            moveSnake()
            if state != .playing {
                break
            }
        }
    }

    // MARK: - Engine

    func moveSnake() {
        if let pending = pendingDirection {
            direction = pending
            pendingDirection = nil
        }

        guard let head = snake.first else { return }
        let nextHead = head.moved(in: direction)

        if checkCollision(nextHead: nextHead) {
            gameOver()
            return
        }

        let willEat = nextHead == food
        snake.insert(nextHead, at: 0)

        if willEat {
            handleFoodConsumption()
        } else {
            snake.removeLast()
        }
    }

    func spawnFood() {
        let snakeCells = Set(snake)
        var empty: [GridPosition] = []
        empty.reserveCapacity(max(0, columns * rows - snake.count))

        for y in 0..<rows {
            for x in 0..<columns {
                let cell = GridPosition(x: x, y: y)
                if !snakeCells.contains(cell) {
                    empty.append(cell)
                }
            }
        }

        guard let next = empty.randomElement() else {
            gameOver(won: true)
            return
        }
        food = next
    }

    func checkCollision(nextHead: GridPosition) -> Bool {
        if !nextHead.isInside(columns: columns, rows: rows) {
            return true
        }

        // The tail vacates on a non-growing move, so occupying that cell is legal.
        let willEat = nextHead == food
        if willEat {
            return snake.contains(nextHead)
        }
        if let tail = snake.last, nextHead == tail {
            return false
        }
        return snake.contains(nextHead)
    }

    func handleFoodConsumption() {
        lastEatenFood = food
        score += GameConfig.pointsPerFood
        eatPulse += 1
        scorePulse += 1
        applyDifficulty()
        sound.playEat(enabled: settings.soundEnabled)
        haptics.eat(enabled: settings.hapticsEnabled)
        spawnFood()
    }

    // MARK: - Private

    private func resetBoard(spawnFood shouldSpawn: Bool) {
        direction = .right
        pendingDirection = nil
        let originX = columns / 2 - 1
        let originY = rows / 2
        snake = (0..<GameConfig.initialLength).map { offset in
            GridPosition(x: originX - offset, y: originY)
        }
        if shouldSpawn {
            food = GridPosition(x: 0, y: 0)
            spawnFood()
        }
    }

    private func applyDifficulty() {
        let bites = score / GameConfig.pointsPerFood
        let reduced = settings.difficulty.baseInterval - (Double(bites) * settings.difficulty.acceleration)
        moveInterval = max(settings.difficulty.minimumInterval, reduced)
    }
}
