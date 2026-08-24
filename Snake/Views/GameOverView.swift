import SwiftUI

struct GameOverView: View {
    let score: Int
    let bestScore: Int
    var didWin: Bool = false
    let onRetry: () -> Void
    let onMenu: () -> Void

    @EnvironmentObject private var ads: AdsManager
    @State private var appeared = false
    @State private var glitch = false

    var body: some View {
        ZStack {
            GamePalette.overlayScrim.ignoresSafeArea()

            Rectangle()
                .fill(GamePalette.danger.opacity(appeared ? 0 : 0.22))
                .ignoresSafeArea()
                .allowsHitTesting(false)

            GeometryReader { geo in
                let cardWidth = min(340, geo.size.width - 40)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        FittedPixelText(
                            text: didWin ? "YOU WIN" : "GAME OVER",
                            preferredSize: 6,
                            weight: .bold,
                            color: didWin ? GamePalette.screenGreen : GamePalette.danger,
                            glow: true
                        )
                        .scaleEffect(appeared ? 1 : 1.12)
                        .offset(x: glitch ? 2 : 0)
                        .opacity(appeared ? 1 : 0)

                        VStack(spacing: 8) {
                            PixelText(text: "SCORE", size: 4, color: GamePalette.screenGreen.opacity(0.7))
                            PixelText(text: String(score), size: 9, weight: .bold, color: GamePalette.screenGreen, glow: true)
                        }

                        VStack(spacing: 8) {
                            PixelText(text: "BEST", size: 4, color: GamePalette.screenGreen.opacity(0.7))
                            PixelText(text: String(bestScore), size: 7, weight: .bold, color: GamePalette.accentGreen)
                        }

                        VStack(spacing: 12) {
                            PixelButton(title: "RETRY", isPrimary: true, action: {
                                ads.showInterstitial(then: onRetry)
                            })
                            PixelButton(title: "MENU", action: {
                                ads.showInterstitial(then: onMenu)
                            })
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
                    .frame(width: cardWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(GamePalette.background.opacity(0.96))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(GamePalette.buttonBorder, lineWidth: 1)
                            )
                    )
                    .frame(maxWidth: .infinity, minHeight: geo.size.height, alignment: .center)
                }
            }
        }
        .onAppear {
            ads.noteGameOver()
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
