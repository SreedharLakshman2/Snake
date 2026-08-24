import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        AdScreenLayout {
            ZStack {
                RetroBackdrop()

                VStack(spacing: 0) {
                    FittedPixelText(
                        text: "ABOUT",
                        preferredSize: 7,
                        weight: .bold,
                        color: GamePalette.screenGreen,
                        glow: true
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 8)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            introCard
                            howToCard
                            scoringCard
                            otherAppsCard
                            footer
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 12)
                    }

                    PixelButton(title: "BACK", action: router.showMenu)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 8)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Brand.appName.uppercased())
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .foregroundColor(GamePalette.screenGreen)
            Text(Brand.tagline)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(GamePalette.textLight)
            Text("Steer a glowing snake across a 20×20 LCD board. Eat fruit, grow longer, and chase a new high score. Walls and your own tail end the run.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(GamePalette.textLight.opacity(0.78))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .retroPanel()
    }

    private var howToCard: some View {
        infoCard(title: "HOW TO PLAY", lines: [
            "Swipe or use the D-pad to turn.",
            "You cannot reverse into yourself.",
            "Eat fruit to grow and score.",
            "Hit a wall or your tail and the game is over.",
            "Fill the board to win."
        ])
    }

    private var scoringCard: some View {
        infoCard(title: "SCORING", lines: [
            "Each fruit is worth 10 points.",
            "The snake speeds up after every bite.",
            "High scores keep the top 10 runs on this iPhone."
        ])
    }

    private func infoCard(title: String, lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            PixelText(text: title, size: 3, color: GamePalette.screenGreen.opacity(0.8))
            ForEach(lines, id: \.self) { line in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(GamePalette.screenGreen)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Text(line)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(GamePalette.textLight.opacity(0.86))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .retroPanel()
    }

    private var otherAppsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PixelText(text: "OTHER APPS", size: 3, color: GamePalette.screenGreen.opacity(0.8))
            Text("More from \(Brand.studioFull)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(GamePalette.textLight.opacity(0.7))

            VStack(spacing: 0) {
                ForEach(Array(DeveloperCatalog.apps.enumerated()), id: \.element.id) { index, app in
                    Link(destination: app.storeURL) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(app.tint.opacity(0.18))
                                Image(systemName: app.symbol)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(app.tint)
                            }
                            .frame(width: 38, height: 38)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(app.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(GamePalette.textLight)
                                Text(app.blurb)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(GamePalette.textLight.opacity(0.55))
                                    .lineLimit(2)
                            }

                            Spacer(minLength: 8)

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(GamePalette.textLight.opacity(0.35))
                        }
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
                    })
                    .accessibilityLabel("\(app.name). \(app.blurb)")
                    .accessibilityHint("Opens in the App Store")

                    if index < DeveloperCatalog.apps.count - 1 {
                        Rectangle()
                            .fill(GamePalette.buttonBorder.opacity(0.7))
                            .frame(height: 1)
                    }
                }
            }

            Link(destination: DeveloperCatalog.storePage) {
                Text("See all apps")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(GamePalette.accentGreen)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("See all apps in the App Store")
        }
        .padding(16)
        .retroPanel()
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text(Brand.studioFull)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .tracking(1.4)
                .foregroundColor(GamePalette.accentGreen)
            Text(Brand.copyrightLine)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(GamePalette.textLight.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}
