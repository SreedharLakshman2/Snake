import SwiftUI
#if canImport(Lottie)
import Lottie
#endif

struct SnakeLottieView: View {
    var body: some View {
        #if canImport(Lottie)
        LottieView(animation: .named("PixelSnake"))
            .playing(loopMode: .loop)
            .resizable()
            .scaledToFit()
            .accessibilityHidden(true)
        #else
        PixelSnakeLogo(walking: true)
        #endif
    }
}
