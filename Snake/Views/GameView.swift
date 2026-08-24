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

    private var showsChrome: Bool {
        viewModel.state == .playing
    }

    var body: some View {
        ZStack {
            RetroBackdrop()

            VStack(spacing: 10) {
                ScoreDisplay(
                    score: viewModel.score,
                    bestScore: viewModel.bestScore,
                    pulse: scorePulse,
                    onPause: { viewModel.pauseGame() }
                )
                .padding(.horizontal, 16)
                .opacity(showsChrome ? 1 : 0)
                .allowsHitTesting(showsChrome)
                .accessibilityHidden(!showsChrome)

                GeometryReader { geo in
                    let cell = cellSize(in: geo.size)
                    LCDBezel {
                        SnakeGameBoard(
                            columns: viewModel.columns,
                            rows: viewModel.rows,
                            cellSize: cell,
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }

                DirectionPad(buttonSize: 56) { direction in
                    viewModel.changeDirection(direction)
                }
                .opacity(showsChrome ? 1 : 0)
                .allowsHitTesting(showsChrome)
                .accessibilityHidden(!showsChrome)
            }
            .padding(.top, 4)
            .padding(.bottom, 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            overlays
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

    private func cellSize(in size: CGSize) -> CGFloat {
        let bezel: CGFloat = 22
        let side = min(size.width, size.height) - bezel
        return max(8, floor(side / CGFloat(viewModel.columns)))
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
