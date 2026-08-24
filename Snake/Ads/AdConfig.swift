import CoreGraphics
import Foundation

enum AdConfig {
    /// Snake iOS app in AdMob. Also set as `GADApplicationIdentifier` in Info.plist.
    static let applicationID = "ca-app-pub-9471606055191983~7219810151"
    static let liveBannerUnitID = "ca-app-pub-9471606055191983/4299072695"
    static let liveInterstitialUnitID = "ca-app-pub-9471606055191983/8860194887"

    static let googleTestBannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let googleTestInterstitialUnitID = "ca-app-pub-3940256099942544/4411468910"

    static var bannerUnitID: String {
        #if DEBUG
        googleTestBannerUnitID
        #else
        liveBannerUnitID
        #endif
    }

    static var interstitialUnitID: String {
        #if DEBUG
        googleTestInterstitialUnitID
        #else
        liveInterstitialUnitID
        #endif
    }

    static let bannerHeight: CGFloat = 50

    static var hidesAds: Bool {
        ProcessInfo.processInfo.arguments.contains("-hideAds")
    }
}
