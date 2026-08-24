import SwiftUI

@main
struct SnakeApp: App {
    @StateObject private var settings = SettingsStore()
    @StateObject private var router = AppRouter()
    @StateObject private var ads = AdsManager()
    @Environment(\.scenePhase) private var scenePhase

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
                    ReviewPrompt.recordFirstUseIfNeeded()
                    ReviewPrompt.noteBecameActive()
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        ReviewPrompt.noteBecameActive()
                    case .inactive, .background:
                        ReviewPrompt.noteBecameInactive()
                    default:
                        break
                    }
                }
        }
    }
}
