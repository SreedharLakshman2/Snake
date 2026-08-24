# Snake

A retro arcade Snake game for iPhone, built with SwiftUI.

## Requirements

- Xcode 16 or later
- iOS 16+
- iPhone, portrait

Open `Snake.xcodeproj` and run the **Snake** scheme.

## Ads

Debug builds use Google sample banner and interstitial units so ads always fill.

Release builds use the Snake AdMob app ID in `Info.plist` (`GADApplicationIdentifier`). Banner and interstitial units for bundle `com.sreeo.snake` are in `Snake/Ads/AdConfig.swift`.

Banners sit on menu, high scores, settings, and about. An interstitial can appear after Game Over once every two games, with a cooldown.

Pass `-hideAds` to hide ads for store screenshots.

## Support

Sreedhar Lakshmanan  
Sreeo / Sai Laksha Technologies
