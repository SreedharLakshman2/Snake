import SwiftUI

struct PixelSnakeLogo: View {
    var walking: Bool = false

    private let bitmap: [String] = [
        "....................",
        "..........11111.....",
        "........11.....11...",
        "........11...11.....",
        "......11111.........",
        "....11....11........",
        "..11......11........",
        ".11111111...........",
        "11......11.....2....",
        ".11....111....222...",
        "..111111.....22222..",
        "..............222...",
        "...............2...."
    ]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: !walking)) { timeline in
            let phase = walking ? timeline.date.timeIntervalSinceReferenceDate : 0
            let bounce = walking ? sin(phase * 3.2) * 3 : 0
            let slide = walking ? sin(phase * 1.4) * 10 : 0

            Canvas { context, size in
                let rows = bitmap.count
                let cols = bitmap.first?.count ?? 1
                let cell = min(size.width / CGFloat(cols), size.height / CGFloat(rows))
                let offsetX = (size.width - cell * CGFloat(cols)) / 2 + slide
                let offsetY = (size.height - cell * CGFloat(rows)) / 2 + bounce

                for (row, line) in bitmap.enumerated() {
                    for (column, scalar) in line.enumerated() {
                        let color: Color?
                        switch scalar {
                        case "1": color = GamePalette.snakeGreen
                        case "2": color = GamePalette.foodRed
                        default: color = nil
                        }
                        guard let color else { continue }
                        let rect = CGRect(
                            x: offsetX + CGFloat(column) * cell,
                            y: offsetY + CGFloat(row) * cell,
                            width: cell,
                            height: cell
                        )
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
        }
        .shadow(color: GamePalette.snakeGreen.opacity(0.35), radius: 10)
        .accessibilityHidden(true)
    }
}

struct RetroBackdrop: View {
    var body: some View {
        ZStack {
            GamePalette.background
            RadialGradient(
                colors: [GamePalette.accentGreen.opacity(0.08), .clear],
                center: .center,
                startRadius: 20,
                endRadius: 320
            )
            VStack {
                Spacer()
                Rectangle()
                    .fill(GamePalette.screenGreen.opacity(0.04))
                    .frame(height: 1)
                    .padding(.bottom, 24)
            }
        }
        .ignoresSafeArea()
    }
}
