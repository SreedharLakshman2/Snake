import AppTrackingTransparency
import Foundation
import UIKit
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

@MainActor
final class AdsManager: NSObject, ObservableObject {
    @Published var isReady = false

    private var didBootstrap = false
    private var isLoadingInterstitial = false
    private var lastInterstitialAt = Date.distantPast
    private var gamesSinceInterstitial = 0
    private var pendingDone: (() -> Void)?

    #if canImport(GoogleMobileAds)
    private var interstitial: InterstitialAd?
    #endif

    func bootstrap() {
        guard !didBootstrap else { return }
        didBootstrap = true
        guard !AdConfig.hidesAds else {
            isReady = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.requestTrackingThenStart()
        }
    }

    func noteGameOver() {
        gamesSinceInterstitial += 1
    }

    func showInterstitial(then done: @escaping () -> Void) {
        if AdConfig.hidesAds || Date().timeIntervalSince(lastInterstitialAt) < 50 || gamesSinceInterstitial < 2 {
            done()
            return
        }
        #if canImport(GoogleMobileAds)
        guard isReady, let ad = interstitial, let root = Self.topViewController() else {
            preloadInterstitial()
            done()
            return
        }
        interstitial = nil
        lastInterstitialAt = Date()
        gamesSinceInterstitial = 0
        pendingDone = done
        ad.fullScreenContentDelegate = self
        ad.present(from: root)
        #else
        done()
        #endif
    }

    private func requestTrackingThenStart() {
        ATTrackingManager.requestTrackingAuthorization { _ in
            Task { @MainActor in
                self.startAds()
            }
        }
    }

    private func startAds() {
        #if canImport(GoogleMobileAds)
        MobileAds.shared.start { [weak self] _ in
            Task { @MainActor in
                self?.isReady = true
                self?.preloadInterstitial()
            }
        }
        #else
        isReady = true
        #endif
    }

    func preloadInterstitial() {
        #if canImport(GoogleMobileAds)
        guard !AdConfig.hidesAds, !isLoadingInterstitial, interstitial == nil else { return }
        isLoadingInterstitial = true
        InterstitialAd.load(with: AdConfig.interstitialUnitID, request: Request()) { [weak self] ad, _ in
            Task { @MainActor in
                self?.isLoadingInterstitial = false
                ad?.fullScreenContentDelegate = self
                self?.interstitial = ad
            }
        }
        #endif
    }

    static func topViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let window = scenes.flatMap(\.windows).first(where: \.isKeyWindow) ?? scenes.first?.windows.first
        var controller = window?.rootViewController
        while let presented = controller?.presentedViewController {
            controller = presented
        }
        return controller
    }
}

#if canImport(GoogleMobileAds)
extension AdsManager: FullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            let done = pendingDone
            pendingDone = nil
            interstitial = nil
            preloadInterstitial()
            done?()
        }
    }

    nonisolated func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            let done = pendingDone
            pendingDone = nil
            interstitial = nil
            preloadInterstitial()
            done?()
        }
    }
}
#endif
