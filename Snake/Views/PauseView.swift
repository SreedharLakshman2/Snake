import SwiftUI

struct PauseView: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onMenu: () -> Void

    var body: some View {
        ZStack {
            GamePalette.overlayScrim.ignoresSafeArea()

            GeometryReader { geo in
                let cardWidth = min(340, geo.size.width - 40)

                VStack(spacing: 22) {
                    FittedPixelText(
                        text: "PAUSED",
                        preferredSize: 8,
                        weight: .bold,
                        color: GamePalette.screenGreen,
                        glow: true
                    )

                    VStack(spacing: 12) {
                        PixelButton(title: "RESUME", isPrimary: true, action: onResume)
                        PixelButton(title: "RESTART", action: onRestart)
                        PixelButton(title: "MENU", action: onMenu)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 28)
                .frame(width: cardWidth)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(GamePalette.background.opacity(0.96))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(GamePalette.buttonBorder, lineWidth: 1)
                        )
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}
