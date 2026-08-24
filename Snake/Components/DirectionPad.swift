import SwiftUI

struct DirectionPad: View {
    let onDirection: (SnakeDirection) -> Void

    var body: some View {
        VStack(spacing: 10) {
            DirectionButton(direction: .up, action: { onDirection(.up) })
            HStack(spacing: 10) {
                DirectionButton(direction: .left, action: { onDirection(.left) })
                DPadNucleus()
                DirectionButton(direction: .right, action: { onDirection(.right) })
            }
            DirectionButton(direction: .down, action: { onDirection(.down) })
        }
        .padding(8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Direction pad")
    }
}

struct DirectionButton: View {
    let direction: SnakeDirection
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(GamePalette.buttonDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(GamePalette.buttonBorder, lineWidth: 1.5)
                    )

                PixelArrow(direction: direction)
                    .fill(GamePalette.screenGreen)
                    .frame(width: 18, height: 18)
            }
            .frame(width: 72, height: 72)
            .contentShape(Rectangle())
        }
        .buttonStyle(DirectionPressStyle())
        .accessibilityLabel(label)
        .accessibilityHint("Steer the snake \(label.lowercased())")
    }

    private var label: String {
        switch direction {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        }
    }
}

private struct DirectionPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .shadow(color: configuration.isPressed ? GamePalette.accentGreen.opacity(0.28) : .clear, radius: 8)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

private struct DPadNucleus: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(GamePalette.buttonDark)
                .overlay(Circle().stroke(GamePalette.buttonBorder, lineWidth: 1))
            Circle()
                .fill(GamePalette.accentGreen.opacity(0.85))
                .frame(width: 14, height: 14)
                .shadow(color: GamePalette.accentGreen.opacity(0.6), radius: 6)
        }
        .frame(width: 72, height: 72)
        .accessibilityHidden(true)
    }
}

private struct PixelArrow: Shape {
    let direction: SnakeDirection

    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch direction {
        case .up:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.72))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.72))
        case .down:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.28))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.28))
        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX * 0.72, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX * 0.72, y: rect.maxY))
        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX * 0.28, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX * 0.28, y: rect.maxY))
        }
        path.closeSubpath()
        return path
    }
}
