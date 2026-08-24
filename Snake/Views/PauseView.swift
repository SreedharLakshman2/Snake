import SwiftUI

struct PauseView: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onMenu: () -> Void

    var body: some View {
        ZStack {
            GamePalette.overlayScrim.ignoresSafeArea()

            VStack(spacing: 22) {
                PixelText(text: "PAUSED", size: 9, weight: .bold, color: GamePalette.screenGreen, glow: true)

                VStack(spacing: 12) {
                    PixelButton(title: "RESUME", isPrimary: true, action: onResume)
                    PixelButton(title: "RESTART", action: onRestart)
                    PixelButton(title: "MENU", action: onMenu)
                }
                .padding(.horizontal, 36)
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(GamePalette.background.opacity(0.94))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(GamePalette.buttonBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 28)
        }
        .accessibilityAddTraits(.isModal)
    }
}
