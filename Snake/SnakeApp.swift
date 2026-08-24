import SwiftUI

@main
struct SnakeApp: App {
    @StateObject private var settings = SettingsStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(router)
                .preferredColorScheme(.dark)
                .dynamicTypeSize(.xSmall ... .xxxLarge)
                .onAppear {
                    SoundManager.shared.prepare()
                }
        }
    }
}
