import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var appeared = false
    @State private var blink = false
    @State private var didAdvance = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RetroBackdrop()

                VStack(spacing: 28) {
                    Spacer()

                    PixelText(
                        text: "SNAKE",
                        size: 12,
                        weight: .bold,
                        color: GamePalette.screenGreen,
                        glow: true,
                        maxWidth: geo.size.width - 48
                    )
                    .scaleEffect(appeared ? 1 : 0.84)
                    .opacity(appeared ? 1 : 0)

                    PixelSnakeLogo(walking: true)
                        .frame(height: min(140, geo.size.height * 0.22))
                        .padding(.horizontal, 24)
                        .opacity(appeared ? 1 : 0)

                    PixelText(
                        text: "PIXEL SNAKE",
                        size: 5,
                        color: GamePalette.accentGreen,
                        maxWidth: geo.size.width - 64
                    )
                    .opacity(appeared ? 0.9 : 0)

                    Spacer()

                    PixelText(
                        text: "PRESS ANY KEY",
                        size: 4,
                        color: GamePalette.textLight,
                        maxWidth: geo.size.width - 48
                    )
                    .opacity(blink ? 1 : 0.22)

                    Text("Tap to continue")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(GamePalette.textLight.opacity(0.45))
                        .padding(.bottom, 36)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { advance() }
        .accessibilityLabel("Snake splash screen")
        .accessibilityHint("Tap to open the main menu")
        .accessibilityAddTraits(.isButton)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                blink = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                advance()
            }
        }
    }

    private func advance() {
        guard !didAdvance else { return }
        didAdvance = true
        router.showMenu()
    }
}
