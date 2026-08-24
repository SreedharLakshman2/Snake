import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var ads: AdsManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    @State private var tracking: CGFloat = 14
    @State private var didAdvance = false

    var body: some View {
        ZStack {
            RetroBackdrop()

            VStack(spacing: 0) {
                Spacer()

                sreeoTiles
                    .padding(.bottom, 18)

                Text(Brand.studio)
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .tracking(tracking)
                    .foregroundColor(GamePalette.accentGreen)
                    .shadow(color: GamePalette.accentGreen.opacity(0.45), radius: 16)
                    .opacity(appeared ? 1 : 0)

                Text("STUDIO")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .tracking(8)
                    .foregroundColor(GamePalette.textLight.opacity(0.55))
                    .padding(.top, 6)
                    .opacity(appeared ? 1 : 0)

                SnakeLottieView()
                    .frame(height: 150)
                    .padding(.top, 28)
                    .opacity(appeared ? 1 : 0)

                Spacer()

                VStack(spacing: 4) {
                    Text(Brand.company.uppercased())
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .tracking(1.6)
                        .foregroundColor(GamePalette.textLight.opacity(0.45))
                    Text(Brand.copyrightLine)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(GamePalette.textLight.opacity(0.4))
                }
                .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            ads.bootstrap()
            withAnimation(reduceMotion ? nil : .spring(response: 0.8, dampingFraction: 0.78)) {
                appeared = true
                tracking = 4
            }
            let delay: TimeInterval = reduceMotion ? 0.9 : 2.2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                advance()
            }
        }
        .accessibilityLabel("\(Brand.studio) Studio. \(Brand.copyrightLine)")
    }

    private var sreeoTiles: some View {
        HStack(spacing: 8) {
            ForEach(Array(Brand.tiles.enumerated()), id: \.offset) { index, color in
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(color)
                    .frame(width: 22, height: 22)
                    .offset(y: appeared || reduceMotion ? 0 : -36)
                    .opacity(appeared ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.62).delay(Double(index) * 0.08),
                        value: appeared
                    )
            }
        }
    }

    private func advance() {
        guard !didAdvance else { return }
        didAdvance = true
        router.showMenu()
    }
}
