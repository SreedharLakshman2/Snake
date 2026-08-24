import SwiftUI

struct FoodRenderer: View {
    let position: GridPosition
    let cellSize: CGFloat
    var pulse: Bool = false

    var body: some View {
        PixelApple()
            .frame(width: cellSize * 0.78, height: cellSize * 0.78)
            .scaleEffect(pulse ? 1.28 : 1)
            .position(
                x: CGFloat(position.x) * cellSize + cellSize / 2,
                y: CGFloat(position.y) * cellSize + cellSize / 2
            )
            .shadow(color: GamePalette.foodRed.opacity(0.45), radius: pulse ? 8 : 3)
            .animation(.spring(response: 0.22, dampingFraction: 0.55), value: pulse)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct PixelApple: View {
    var body: some View {
        Canvas { context, size in
            let unit = size.width / 7
            func pixel(_ x: CGFloat, _ y: CGFloat, _ color: Color, w: CGFloat = 1, h: CGFloat = 1) {
                let rect = CGRect(x: x * unit, y: y * unit, width: w * unit, height: h * unit)
                context.fill(Path(rect), with: .color(color))
            }

            pixel(3, 0, GamePalette.screenGreen)
            pixel(4, 1, Color(hex: 0x3D8A2E), w: 2)
            pixel(1, 2, GamePalette.foodRed, w: 5, h: 4)
            pixel(0, 3, GamePalette.foodRed, w: 7, h: 2)
            pixel(2, 6, GamePalette.foodRed, w: 3)
            pixel(2, 3, Color.white.opacity(0.35), w: 1, h: 1)
        }
    }
}
