import SwiftUI

struct SnakeRenderer: View {
    let segments: [SnakeSegment]
    let cellSize: CGFloat
    let direction: SnakeDirection

    var body: some View {
        Canvas { context, _ in
            for (index, segment) in segments.enumerated() {
                let inset: CGFloat = segment.isHead ? 1.2 : 1.8
                let rect = CGRect(
                    x: CGFloat(segment.position.x) * cellSize + inset,
                    y: CGFloat(segment.position.y) * cellSize + inset,
                    width: cellSize - inset * 2,
                    height: cellSize - inset * 2
                )
                let color = fill(for: index, count: segments.count, isHead: segment.isHead)
                context.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(color))

                if segment.isHead {
                    drawEyes(in: &context, rect: rect)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func fill(for index: Int, count: Int, isHead: Bool) -> Color {
        if isHead { return GamePalette.snakeHead }
        let t = count <= 1 ? 0 : Double(index) / Double(count - 1)
        return GamePalette.snakeGreen.opacity(1.0 - t * 0.22)
    }

    private func drawEyes(in context: inout GraphicsContext, rect: CGRect) {
        let eye: CGFloat = max(1.6, rect.width * 0.16)
        let (left, right): (CGPoint, CGPoint)
        switch direction {
        case .up:
            left = CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.28)
            right = CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.28)
        case .down:
            left = CGPoint(x: rect.minX + rect.width * 0.28, y: rect.maxY - rect.height * 0.28)
            right = CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.maxY - rect.height * 0.28)
        case .left:
            left = CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.28)
            right = CGPoint(x: rect.minX + rect.width * 0.28, y: rect.maxY - rect.height * 0.28)
        case .right:
            left = CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.28)
            right = CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.maxY - rect.height * 0.28)
        }
        let eyeColor = GraphicsContext.Shading.color(GamePalette.background)
        context.fill(Path(ellipseIn: CGRect(x: left.x - eye / 2, y: left.y - eye / 2, width: eye, height: eye)), with: eyeColor)
        context.fill(Path(ellipseIn: CGRect(x: right.x - eye / 2, y: right.y - eye / 2, width: eye, height: eye)), with: eyeColor)
    }
}
