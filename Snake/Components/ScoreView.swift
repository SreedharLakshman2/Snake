import SwiftUI

struct ScoreDisplay: View {
    let score: Int
    let bestScore: Int
    var pulse: Bool = false
    var onPause: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            scoreBlock(title: "SCORE", value: score, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .scaleEffect(pulse ? 1.08 : 1)
                .animation(.spring(response: 0.22, dampingFraction: 0.6), value: pulse)

            if let onPause {
                Button(action: onPause) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(GamePalette.buttonDark)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(GamePalette.buttonBorder, lineWidth: 1)
                            )
                        Image(systemName: "pause.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(GamePalette.screenGreen)
                    }
                    .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Pause")
                .accessibilityHint("Pauses the current game")
            }

            scoreBlock(title: "BEST", value: bestScore, alignment: .trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func scoreBlock(title: String, value: Int, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 5) {
            PixelText(text: title, size: 3, color: GamePalette.screenGreen.opacity(0.7))
            PixelText(text: String(value), size: 6, weight: .bold, color: GamePalette.screenGreen, glow: true)
        }
    }
}

struct ScoreView: View {
    let score: Int
    let bestScore: Int

    var body: some View {
        ScoreDisplay(score: score, bestScore: bestScore)
    }
}
