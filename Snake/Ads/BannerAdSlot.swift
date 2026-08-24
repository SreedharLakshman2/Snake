import SwiftUI
#if canImport(GoogleMobileAds)
import GoogleMobileAds
import UIKit
#endif

struct BannerAdSlot: View {
    @EnvironmentObject private var ads: AdsManager

    var body: some View {
        if AdConfig.hidesAds {
            EmptyView()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(GamePalette.buttonDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(GamePalette.buttonBorder, lineWidth: 1)
                    )
                Text("AD")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(GamePalette.textLight.opacity(0.35))
                #if canImport(GoogleMobileAds)
                if ads.isReady {
                    GoogleAdBannerView()
                }
                #endif
            }
            .frame(maxWidth: .infinity)
            .frame(height: AdConfig.bannerHeight)
            .padding(.horizontal, 16)
            .padding(.bottom, 6)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Advertisement")
        }
    }
}

struct AdScreenLayout<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            BannerAdSlot()
        }
    }
}

#if canImport(GoogleMobileAds)
private struct GoogleAdBannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BannerHostController {
        BannerHostController()
    }

    func updateUIViewController(_ uiViewController: BannerHostController, context: Context) {}
}

private final class BannerHostController: UIViewController, BannerViewDelegate {
    private let banner = BannerView(adSize: AdSizeBanner)
    private var didRequest = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        banner.backgroundColor = .clear
        banner.adUnitID = AdConfig.bannerUnitID
        banner.delegate = self
        banner.rootViewController = self
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAd()
    }

    private func loadAd() {
        guard didRequest == false else { return }
        didRequest = true
        banner.rootViewController = self
        banner.load(Request())
    }

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        bannerView.isHidden = false
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        bannerView.isHidden = true
        didRequest = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.loadAd()
        }
    }
}
#endif
