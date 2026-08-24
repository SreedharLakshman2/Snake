import SwiftUI

struct GameView: View {
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        GamePlayView(settings: settings)
    }
}

private struct GamePlayView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: SnakeGameViewModel

    @State private var particles: [EatParticle] = []
    @State private var particleSerial = 0
    @State private var foodPulse = false
    @State private var scorePulse = false

    init(settings: SettingsStore) {
        _viewModel = StateObject(
            wrappedValue: SnakeGameViewModel(
                settings: settings,
                highScores: HighScoreManager.shared
            )
        )
    }

    var body: some View {
        GeometryReader { geo in
            playfield(size: geo.size)
        }
        .onAppear { viewModel.startGame() }
        .onDisappear { viewModel.stopLoop() }
        .onChange(of: scenePhase) { phase in
            viewModel.handleScenePhase(phase)
        }
        .onChange(of: viewModel.eatPulse) { pulse in
            handleEat(pulse)
        }
    }

    private func playfield(size: CGSize) -> some View {
        let metrics = layout(in: size)
        return ZStack {
            RetroBackdrop()
            gameColumn(metrics: metrics)
            overlays
        }
    }

    private func gameColumn(metrics: BoardMetrics) -> some View {
        VStack(spacing: 12) {
            ScoreDisplay(
                score: viewModel.score,
                bestScore: viewModel.bestScore,
                pulse: scorePulse,
                onPause: { viewModel.pauseGame() }
            )
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer(minLength: 0)

            LCDBezel {
                SnakeGameBoard(
                    columns: viewModel.columns,
                    rows: viewModel.rows,
                    cellSize: metrics.cellSize,
                    snake: viewModel.segments,
                    food: viewModel.food,
                    direction: viewModel.direction,
                    showGrid: settings.gridEnabled,
                    foodPulse: foodPulse,
                    lastEatenFood: viewModel.lastEatenFood,
                    particles: particles
                )
                .gesture(swipeGesture)
            }

            Spacer(minLength: 0)

            DirectionPad { direction in
                viewModel.changeDirection(direction)
            }
            .scaleEffect(metrics.padScale)
            .opacity(viewModel.state == .playing ? 1 : 0.45)
            .allowsHitTesting(viewModel.state == .playing)
            .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private var overlays: some View {
        if viewModel.state == .paused {
            PauseView(
                onResume: { viewModel.resumeGame() },
                onRestart: { viewModel.restartGame() },
                onMenu: goMenu
            )
        }

        if viewModel.state == .gameOver {
            GameOverView(
                score: viewModel.score,
                bestScore: viewModel.bestScore,
                didWin: viewModel.didWin,
                onRetry: { viewModel.restartGame() },
                onMenu: goMenu
            )
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 24)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                if abs(horizontal) > abs(vertical) {
                    viewModel.changeDirection(horizontal > 0 ? .right : .left)
                } else {
                    viewModel.changeDirection(vertical > 0 ? .down : .up)
                }
            }
    }

    private func layout(in size: CGSize) -> BoardMetrics {
        let compact = size.height < 720
        let padScale: CGFloat = compact ? 0.86 : 1
        let padHeight: CGFloat = compact ? 236 : 276
        let availableWidth = max(160, size.width - 40)
        let availableHeight = max(160, size.height - 86 - padHeight)
        let boardSide = min(availableWidth, availableHeight)
        let cell = floor(boardSide / CGFloat(viewModel.columns))
        return BoardMetrics(cellSize: max(8, cell), padScale: padScale)
    }

    private func handleEat(_ pulse: Int) {
        guard pulse > 0, let origin = viewModel.lastEatenFood else { return }
        foodPulse = true
        scorePulse = true
        let now = Date()
        var burst: [EatParticle] = []
        for index in 0..<8 {
            particleSerial += 1
            burst.append(
                EatParticle(
                    id: particleSerial,
                    origin: origin,
                    angle: (Double(index) / 8.0) * .pi * 2.0,
                    createdAt: now
                )
            )
        }
        particles.append(contentsOf: burst)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            foodPulse = false
            scorePulse = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            particles.removeAll { now.timeIntervalSince($0.createdAt) > 0.35 }
        }
    }

    private func goMenu() {
        viewModel.stopLoop()
        router.showMenu()
    }
}

private struct BoardMetrics {
    let cellSize: CGFloat
    let padScale: CGFloat
}
