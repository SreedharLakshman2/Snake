import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RetroBackdrop()

                VStack(spacing: 0) {
                    Spacer(minLength: 16)

                    PixelText(
                        text: "SNAKE",
                        size: 11,
                        weight: .bold,
                        color: GamePalette.screenGreen,
                        glow: true,
                        maxWidth: geo.size.width - 48
                    )

                    PixelSnakeLogo(walking: true)
                        .frame(height: min(120, geo.size.height * 0.18))
                        .padding(.top, 18)
                        .padding(.bottom, 28)

                    VStack(spacing: 12) {
                        PixelButton(title: "PLAY", isPrimary: true, action: router.play)
                            .accessibilityHint("Starts a new snake game")

                        PixelButton(title: "HIGH SCORE", systemImage: "trophy.fill", action: router.showHighScore)
                        PixelButton(title: "SETTINGS", systemImage: "gearshape.fill", action: router.showSettings)
                        PixelButton(title: "ABOUT", systemImage: "info.circle.fill", action: router.showAbout)
                    }
                    .padding(.horizontal, 28)

                    Spacer(minLength: 20)

                    HStack(spacing: 28) {
                        menuGlyph(systemName: "trophy.fill", label: "Scores", action: router.showHighScore)
                        menuGlyph(
                            systemName: settings.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill",
                            label: settings.soundEnabled ? "Sound on" : "Sound off"
                        ) {
                            settings.soundEnabled.toggle()
                            SoundManager.shared.playButton(enabled: settings.soundEnabled)
                        }
                        menuGlyph(systemName: "star.fill", label: "About", action: router.showAbout)
                    }
                    .padding(.bottom, 28)
                }
            }
        }
    }

    private func menuGlyph(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(GamePalette.screenGreen)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .stroke(GamePalette.buttonBorder, lineWidth: 1)
                        .background(Circle().fill(GamePalette.buttonDark))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
