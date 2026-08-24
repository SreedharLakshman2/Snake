import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        AdScreenLayout {
            GeometryReader { geo in
                ZStack {
                    RetroBackdrop()

                    VStack(spacing: 0) {
                        Spacer(minLength: 10)

                        PixelText(
                            text: "SNAKELET",
                            size: 11,
                            weight: .bold,
                            color: GamePalette.screenGreen,
                            glow: true,
                            maxWidth: geo.size.width - 48
                        )

                        SnakeLottieView()
                            .frame(height: min(132, geo.size.height * 0.22))
                            .padding(.top, 8)
                            .padding(.bottom, 16)

                        VStack(spacing: 12) {
                            PixelButton(title: "PLAY", isPrimary: true, action: router.play)
                                .accessibilityHint("Starts a new snake game")

                            PixelButton(title: "HIGH SCORE", systemImage: "trophy.fill", action: router.showHighScore)
                            PixelButton(title: "SETTINGS", systemImage: "gearshape.fill", action: router.showSettings)
                            PixelButton(title: "ABOUT", systemImage: "info.circle.fill", action: router.showAbout)
                        }
                        .padding(.horizontal, 28)

                        Spacer(minLength: 8)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
    }
}
