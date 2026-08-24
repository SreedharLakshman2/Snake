import SwiftUI

@main
struct SnakeApp: App {
    @StateObject private var settings = SettingsStore()
    @StateObject private var router = AppRouter()
    @StateObject private var ads = AdsManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(router)
                .environmentObject(ads)
                .preferredColorScheme(.dark)
                .dynamicTypeSize(.xSmall ... .xxxLarge)
                .onAppear {
                    SoundManager.shared.prepare()
                }
        }
    }
}
