import SwiftUI

struct RootView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            GamePalette.background.ignoresSafeArea()

            switch router.screen {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .menu:
                MainMenuView()
                    .transition(.opacity)
            case .game:
                GameView()
                    .transition(.opacity)
            case .highScore:
                HighScoreView()
                    .transition(.opacity)
            case .settings:
                SettingsView()
                    .transition(.opacity)
            case .about:
                AboutView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.28), value: router.screen)
    }
}
