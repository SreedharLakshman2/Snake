import SwiftUI

struct GameOverView: View {
    let score: Int
    let bestScore: Int
    var didWin: Bool = false
    let onRetry: () -> Void
    let onMenu: () -> Void

    @State private var appeared = false
    @State private var glitch = false

    var body: some View {
        ZStack {
            GamePalette.overlayScrim.ignoresSafeArea()

            Rectangle()
                .fill(GamePalette.danger.opacity(appeared ? 0 : 0.28))
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 18) {
                PixelText(
                    text: didWin ? "YOU WIN" : "GAME OVER",
                    size: didWin ? 8 : 7,
                    weight: .bold,
                    color: didWin ? GamePalette.screenGreen : GamePalette.danger,
                    glow: true
                )
                .scaleEffect(appeared ? 1 : 1.18)
                .offset(x: glitch ? 3 : 0)
                .opacity(appeared ? 1 : 0)

                VStack(spacing: 10) {
                    PixelText(text: "SCORE", size: 4, color: GamePalette.screenGreen.opacity(0.7))
                    PixelText(text: String(score), size: 10, weight: .bold, color: GamePalette.screenGreen, glow: true)
                    PixelText(text: "BEST", size: 4, color: GamePalette.screenGreen.opacity(0.7))
                        .padding(.top, 8)
                    PixelText(text: String(bestScore), size: 8, weight: .bold, color: GamePalette.accentGreen)
                }

                VStack(spacing: 12) {
                    PixelButton(title: "RETRY", isPrimary: true, action: onRetry)
                    PixelButton(title: "MENU", action: onMenu)
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(GamePalette.background.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(GamePalette.buttonBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 28)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.18)) {
                appeared = true
            }
            withAnimation(.linear(duration: 0.07).repeatCount(8, autoreverses: true)) {
                glitch = true
            }
        }
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel(didWin ? "You win" : "Game over")
    }
}
