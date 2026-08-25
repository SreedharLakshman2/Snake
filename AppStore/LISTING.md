# Snakelet — App Store listing

Paste these fields into [App Store Connect](https://appstoreconnect.apple.com).

The name **Snake** is already taken. Use **Snakelet**. Keep bundle ID `com.sreeo.snake`.

## Identity

| Field | Value |
| --- | --- |
| **Name** (30) | Snakelet |
| **Subtitle** (30) | Eat, grow, beat your best |
| **Bundle ID** | `com.sreeo.snake` |
| **SKU** | `sreeo-snake-001` |
| **Primary language** | English (U.S.) |
| **Primary category** | Games |
| **Secondary category** | Arcade |
| **Copyright** | © 2026 Sai Laksha Technologies |
| **Version** | 1.0 |
| **Build** | 1 |
| **Age rating** | 4+ |
| **Made for Kids** | No |
| **Studio** | Sreeo Studio |
| **Company / seller** | Sai Laksha Technologies |
| **Developer of record** | Sreedhar Lakshmanan |
| **Apple team** | `7DS2M392U2` |

## URLs (required)

These pages are public on GitHub Pages. Reviewers can open them without signing in.

| Field | Paste this |
| --- | --- |
| **Support URL** | https://sreedharlakshman2.github.io/snake/ |
| **Privacy Policy URL** | https://sreedharlakshman2.github.io/snake/privacy.html |
| **Marketing URL** | https://sreedharlakshman2.github.io |

Support email in App Review Information: **sreedharlakshmanan4@gmail.com**

Do not use a private GitHub repo URL.

## Promotional text (170)

Snakelet is classic Snake on a glowing LCD. Eat fruit, grow, and chase a high score. Pick a snake color and fruit, then beat your best.

## Description

Snakelet is a retro arcade Snake game from Sreeo Studio. Steer a glowing snake across a 20×20 LCD board. Eat fruit, grow longer, and chase a new high score.

HOW TO PLAY
• The snake moves on its own. Turn with the D-pad or a swipe.
• You cannot reverse into yourself.
• Eat fruit to grow and score. Each fruit is 10 points.
• The snake speeds up after every bite.
• Hit a wall or your tail and the run is over. Fill the board to win.

MAKE IT YOURS
• Sound, haptics, and grid on or off
• Easy, Normal, or Hard
• Eight snake colors
• Eight fruit styles
• Top 10 high scores on this iPhone
• Rate Snakelet from Settings or About

Snakelet is free. A small banner can appear on the menu, and a full-screen ad may show after Game Over. There is no account. Scores stay on this device.

A Sreeo Studio app
Sai Laksha Technologies

## Keywords (100)

snakelet,snake,arcade,retro,classic,high score,pixel,casual,fruit,lcd

## What’s New (1.0)

First release. Snakelet is classic Snake with color and fruit options, high scores, and a retro LCD look.

## Age rating questionnaire

Choose **None** / **No** unless listed.

| Question | Answer |
| --- | --- |
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Prolonged Graphic or Sadistic Realistic Violence | None |
| Profanity or Crude Humor | None |
| Mature/Suggestive Themes | None |
| Horror/Fear Themes | None |
| Medical/Treatment Information | None |
| Alcohol, Tobacco, or Drug Use or References | None |
| Simulated Gambling | None |
| Sexual Content or Nudity | None |
| Graphic Sexual Content and Nudity | None |
| Unrestricted Web Access | No |
| Gambling and Contests | No |
| **Advertising** | **Yes** |
| Made for Kids | **No** |

Result: **4+**

## App Privacy (nutrition label)

Tracking is optional (App Tracking Transparency). Scores are not linked to an account.

Declare:

**Data Used to Track You** (only if the user allows tracking)
- Device ID — Third-Party Advertising (Google AdMob)

**Data Not Linked to the User**
- Advertising Data — Third-Party Advertising
- Device ID — Third-Party Advertising

Do **not** declare high scores. They stay on the device and are not used for advertising.

Privacy policy: **https://sreedharlakshman2.github.io/snake/privacy.html**

## App Store icon

Upload is taken from the app binary. A 1024×1024 RGB PNG (no alpha, no rounded iOS mask) is also at:

`AppStore/icons/AppIcon-1024.png`

Rebuild the icon from the project with:

```
python3 Tools/make_icon.py
```

## AdMob app-ads.txt

AdMob crawls the **developer website root**, not the Snakelet folder.

1. In [AdMob](https://apps.admob.com) open **Apps → Snakelet → App settings → App-ads.txt**.
2. Set the developer website to **https://sreedharlakshman2.github.io**
3. Confirm these files stay at the site root (same publisher line):
   - https://sreedharlakshman2.github.io/app-ads.txt
   - https://sreedharlakshman2.github.io/ads.txt

```
google.com, pub-9471606055191983, DIRECT, f08c47fec0942fa0
```

Verification can take up to 24 hours after the first crawl.

Live ad units (Release builds):

| Unit | ID |
| --- | --- |
| App ID | `ca-app-pub-9471606055191983~7219810151` |
| Banner | `ca-app-pub-9471606055191983/4299072695` |
| Interstitial | `ca-app-pub-9471606055191983/8860194887` |

## Screenshots

iPhone only. Upload **iPhone 6.9"** (1320 × 2868) from `AppStore/Screenshots/iPhone-6.9/`. Skip 6.7" and iPad.

| Order | File | Poster |
| --- | --- | --- |
| 1 | `01-play.png` | Eat. Grow. Beat your best. |
| 2 | `02-grow.png` | Chase the fruit. |
| 3 | `03-style.png` | Make it yours. |

Rebuild:

```
python3 Tools/capture_store_screenshots.py
python3 Tools/compose_store_posters.py
```

Capture uses `-hideAds` and `-shot menu|game|settings`. Hide ads with `-hideAds` for any extra Simulator shots.

| Size | Typical device | Pixels |
| --- | --- | --- |
| 6.9" | iPhone 16 Pro Max | 1320 × 2868 |

## Review notes

Paste into **App Review Information → Notes**, and into the Resolution Center reply if Apple asks Guideline 2.1 Information Needed.

Thank you for reviewing Snakelet 1.0.

Snakelet is a single-player arcade Snake game for iPhone. There is no account, no login, no in-app purchase, no user-generated content, and no paid unlocks. High scores stay on this device. The App Store name is Snakelet because Snake is already in use. Bundle ID is com.sreeo.snake.

1. Screen recording
Please see the attached recording from a physical iPhone. It shows: launch and Sreeo splash, App Tracking Transparency (Allow or Ask App Not to Track — both work), Play, steering with the D-pad or a swipe, eating fruit, Game Over, Settings (snake color and fruit), Rate Snakelet, High Score, and About. There is no login, no paid content, no user-generated content, and no extra permission prompts beyond optional tracking for ads.

2. Devices and OS tested before submission
- iPhone 16 Pro Max Simulator, iOS 18.2
- Please add your physical iPhone model and iOS version here (required by App Review).

3. Purpose and audience
Snakelet is a casual retro arcade game. The player steers a snake on a 20×20 LCD board, eats fruit, grows, and tries to beat a local high score. It is for a general audience, age rating 4+, not Made for Kids.

4. How to use the main features
No credentials or sample files are required.
- Launch the app. After the splash, tap Play.
- If iOS shows App Tracking Transparency, choose Allow or Ask App Not to Track. Ads still load either way.
- Steer with the on-screen D-pad or a swipe. You cannot reverse into yourself.
- Eat fruit to score 10 points. The snake speeds up after every bite.
- Hit a wall or your tail for Game Over. Fill the board to win.
- Settings: sound, haptics, grid, Easy/Normal/Hard, eight snake colors, eight fruits.
- High Score keeps the top 10 runs on this iPhone.
- About has other apps, Support, Privacy, and Rate Snakelet (Apple’s in-app review dialog; Apple limits how often it appears).
- A Google banner can appear on menu, scores, settings, and About. An interstitial may appear after Game Over.

5. External services
- Apple StoreKit — in-app rating prompt only. We do not receive the star rating.
- Google AdMob — banner and interstitial ads so the app can stay free.
  App ID ca-app-pub-9471606055191983~7219810151
  Banner ca-app-pub-9471606055191983/4299072695
  Interstitial ca-app-pub-9471606055191983/8860194887
No authentication, payments, cloud backend, analytics SDK of our own, or AI services.

6. Regional differences
The app works the same in every region. There is no region-locked content.

7. Regulated industry / third-party material
Not applicable. Original game. No healthcare, finance, or licensed third-party IP.

Support: https://sreedharlakshman2.github.io/snake/
Privacy: https://sreedharlakshman2.github.io/snake/privacy.html
Contact: sreedharlakshmanan4@gmail.com

## Submit checklist

1. Support URL: https://sreedharlakshman2.github.io/snake/
2. Privacy Policy URL: https://sreedharlakshman2.github.io/snake/privacy.html
3. Marketing URL: https://sreedharlakshman2.github.io
4. Age rating 4+; Advertising = Yes; not Made for Kids
5. App Privacy: Device ID + Advertising Data for AdMob; tracking only if the user allows ATT
6. 1024 icon is RGB with no alpha (`AppStore/icons/AppIcon-1024.png`)
7. AdMob developer website is https://sreedharlakshman2.github.io so app-ads.txt verifies
8. Create the App Store Connect record as **Snakelet** (not Snake), then archive a **Release** build and upload to that existing app
