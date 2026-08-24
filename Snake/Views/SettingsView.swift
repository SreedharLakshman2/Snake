import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    private let optionColumns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        AdScreenLayout {
            ZStack {
                RetroBackdrop()

                VStack(spacing: 0) {
                    FittedPixelText(text: "SETTINGS", preferredSize: 6, weight: .bold, color: GamePalette.screenGreen, glow: true)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        .padding(.bottom, 10)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            VStack(spacing: 0) {
                                SettingsToggleRow(title: "Sound", isOn: $settings.soundEnabled)
                                rowDivider
                                SettingsToggleRow(title: "Haptics", isOn: $settings.hapticsEnabled)
                                rowDivider
                                SettingsToggleRow(title: "Grid", isOn: $settings.gridEnabled)
                            }
                            .retroPanel()

                            colorCard
                            fruitCard
                            difficultyCard
                            rateCard
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 12)
                    }

                    PixelButton(title: "BACK", action: router.showMenu)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 8)
                }
            }
        }
    }

    private var colorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PixelText(text: "SNAKE COLOR", size: 4, color: GamePalette.screenGreen.opacity(0.75))

            LazyVGrid(columns: optionColumns, spacing: 10) {
                ForEach(SnakeColorTheme.allCases) { theme in
                    Button {
                        settings.snakeTheme = theme
                        HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
                        SoundManager.shared.playButton(enabled: settings.soundEnabled)
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(theme.shadow)
                                    .frame(width: 36, height: 36)
                                Circle()
                                    .fill(theme.body)
                                    .frame(width: 28, height: 28)
                                Circle()
                                    .fill(theme.head)
                                    .frame(width: 12, height: 12)
                            }
                            .padding(4)
                            .overlay(
                                Circle()
                                    .stroke(settings.snakeTheme == theme ? GamePalette.screenGreen : Color.clear, lineWidth: 2)
                            )

                            Text(theme.title.uppercased())
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(settings.snakeTheme == theme ? GamePalette.screenGreen : GamePalette.textLight.opacity(0.65))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(theme.title)
                    .accessibilityAddTraits(settings.snakeTheme == theme ? [.isButton, .isSelected] : .isButton)
                }
            }
        }
        .padding(16)
        .retroPanel()
    }

    private var fruitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PixelText(text: "FRUIT", size: 4, color: GamePalette.screenGreen.opacity(0.75))

            LazyVGrid(columns: optionColumns, spacing: 10) {
                ForEach(FruitKind.allCases) { fruit in
                    Button {
                        settings.fruitKind = fruit
                        HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
                        SoundManager.shared.playButton(enabled: settings.soundEnabled)
                    } label: {
                        VStack(spacing: 6) {
                            PixelFruit(kind: fruit)
                                .frame(width: 34, height: 34)
                                .padding(6)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(GamePalette.lcdWell)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(
                                            settings.fruitKind == fruit ? GamePalette.screenGreen : GamePalette.buttonBorder,
                                            lineWidth: settings.fruitKind == fruit ? 2 : 1
                                        )
                                )

                            Text(fruit.title.uppercased())
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(settings.fruitKind == fruit ? GamePalette.screenGreen : GamePalette.textLight.opacity(0.65))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(fruit.title)
                    .accessibilityAddTraits(settings.fruitKind == fruit ? [.isButton, .isSelected] : .isButton)
                }
            }
        }
        .padding(16)
        .retroPanel()
    }

    private var difficultyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PixelText(text: "DIFFICULTY", size: 4, color: GamePalette.screenGreen.opacity(0.75))
                .padding(.horizontal, 4)

            ForEach(Difficulty.allCases) { level in
                Button {
                    settings.difficulty = level
                    HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
                    SoundManager.shared.playButton(enabled: settings.soundEnabled)
                } label: {
                    HStack(spacing: 14) {
                        RetroRadio(isOn: settings.difficulty == level)
                        Text(level.title.uppercased())
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(GamePalette.textLight)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(level.title)
                .accessibilityAddTraits(settings.difficulty == level ? [.isButton, .isSelected] : .isButton)
            }
        }
        .padding(18)
        .retroPanel()
    }

    private var rateCard: some View {
        Button {
            HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
            SoundManager.shared.playButton(enabled: settings.soundEnabled)
            ReviewPrompt.requestReview()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(GamePalette.screenGreen)
                Text("RATE SNAKE")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(GamePalette.textLight)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(GamePalette.textLight.opacity(0.35))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Rate Snake")
        .accessibilityHint("Opens Apple's rating card")
        .retroPanel()
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(GamePalette.buttonBorder.opacity(0.7))
            .frame(height: 1)
    }
}

private struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        Button {
            isOn.toggle()
            HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
            SoundManager.shared.playButton(enabled: settings.soundEnabled)
        } label: {
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(GamePalette.textLight)
                Spacer()
                Text(isOn ? "ON" : "OFF")
                    .font(.system(size: 16, weight: .heavy, design: .monospaced))
                    .foregroundColor(isOn ? GamePalette.screenGreen : GamePalette.textLight.opacity(0.45))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) \(isOn ? "on" : "off")")
        .accessibilityHint("Double tap to toggle")
    }
}

private struct RetroRadio: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(GamePalette.screenGreen, lineWidth: 2)
                .frame(width: 22, height: 22)
            if isOn {
                Circle()
                    .fill(GamePalette.screenGreen)
                    .frame(width: 10, height: 10)
            }
        }
    }
}
