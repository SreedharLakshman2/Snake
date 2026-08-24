import SwiftUI

struct SnakeGameBoard: View {
    let columns: Int
    let rows: Int
    let cellSize: CGFloat
    let snake: [SnakeSegment]
    let food: GridPosition
    let direction: SnakeDirection
    let showGrid: Bool
    var foodPulse: Bool = false
    var lastEatenFood: GridPosition? = nil
    var particles: [EatParticle] = []

    var boardSize: CGSize {
        CGSize(width: CGFloat(columns) * cellSize, height: CGFloat(rows) * cellSize)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(GamePalette.lcdWell)

            if showGrid {
                GridDots(columns: columns, rows: rows, cellSize: cellSize)
            }

            if let eaten = lastEatenFood, foodPulse {
                FoodRenderer(position: eaten, cellSize: cellSize, pulse: true)
            }
            FoodRenderer(position: food, cellSize: cellSize, pulse: false)
            SnakeRenderer(segments: snake, cellSize: cellSize, direction: direction)

            ParticleBurst(particles: particles, cellSize: cellSize)
            ScanlineOverlay()
            LCDVignette()
        }
        .frame(width: boardSize.width, height: boardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(GamePalette.screenGreen.opacity(0.18), lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Game board")
        .accessibilityHint("Swipe or use the direction pad to steer")
    }
}

private struct GridDots: View {
    let columns: Int
    let rows: Int
    let cellSize: CGFloat

    var body: some View {
        Canvas { context, _ in
            let dot: CGFloat = max(1, cellSize * 0.08)
            for y in 0..<rows {
                for x in 0..<columns {
                    let rect = CGRect(
                        x: CGFloat(x) * cellSize + cellSize / 2 - dot / 2,
                        y: CGFloat(y) * cellSize + cellSize / 2 - dot / 2,
                        width: dot,
                        height: dot
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(GamePalette.gridDot))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct ScanlineOverlay: View {
    var body: some View {
        Canvas { context, size in
            var y: CGFloat = 0
            while y < size.height {
                let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                context.fill(Path(rect), with: .color(Color.black.opacity(0.16)))
                y += 3
            }
        }
        .allowsHitTesting(false)
    }
}

private struct LCDVignette: View {
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [.clear, Color.black.opacity(0.28)],
                    center: .center,
                    startRadius: 40,
                    endRadius: 260
                )
            )
            .allowsHitTesting(false)
    }
}

struct LCDBezel<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(GamePalette.lcdBezel)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(GamePalette.lcdHighlight.opacity(0.7), lineWidth: 1)
            )
            .shadow(color: GamePalette.accentGreen.opacity(0.12), radius: 18)
    }
}
