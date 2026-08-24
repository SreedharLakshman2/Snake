import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AdScreenLayout {
            ZStack {
                RetroBackdrop()

                VStack(spacing: 18) {
                    Spacer(minLength: 12)

                    FittedPixelText(
                        text: "SNAKE",
                        preferredSize: 9,
                        weight: .bold,
                        color: GamePalette.screenGreen,
                        glow: true
                    )
                    .padding(.horizontal, 24)

                    SnakeLottieView()
                        .frame(height: 140)

                    VStack(spacing: 8) {
                        Text(Brand.developer)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(GamePalette.textLight)
                        Text(Brand.studioFull)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .tracking(2)
                            .foregroundColor(GamePalette.accentGreen)
                        Text(Brand.copyrightLine)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(GamePalette.textLight.opacity(0.5))
                            .padding(.top, 4)
                    }
                    .multilineTextAlignment(.center)

                    Spacer()

                    PixelButton(title: "BACK", action: router.showMenu)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 8)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}
