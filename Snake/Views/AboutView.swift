import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            RetroBackdrop()

            VStack(spacing: 20) {
                Spacer(minLength: 24)

                PixelText(text: "SNAKE", size: 10, weight: .bold, color: GamePalette.screenGreen, glow: true)
                PixelSnakeLogo(walking: false)
                    .frame(height: 88)

                VStack(spacing: 10) {
                    Text(Brand.tagline)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(GamePalette.textLight)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Text("Built with SwiftUI")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(GamePalette.accentGreen)
                        .padding(.top, 8)

                    Text("Version \(Brand.version)")
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundColor(GamePalette.textLight.opacity(0.7))
                }

                Spacer()

                VStack(spacing: 6) {
                    Text(Brand.company)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(GamePalette.textLight.opacity(0.55))
                    Text(Brand.supportEmail)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(GamePalette.screenGreen.opacity(0.8))
                    Text(Brand.copyrightLine)
                        .font(.system(size: 11))
                        .foregroundColor(GamePalette.textLight.opacity(0.35))
                }

                PixelButton(title: "BACK", action: router.showMenu)
                    .padding(.horizontal, 28)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
        .accessibilityElement(children: .contain)
    }
}
