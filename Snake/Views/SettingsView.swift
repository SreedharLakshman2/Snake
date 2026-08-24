import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        ZStack {
            RetroBackdrop()

            VStack(spacing: 24) {
                PixelText(text: "SETTINGS", size: 7, weight: .bold, color: GamePalette.screenGreen, glow: true)
                    .padding(.top, 18)

                VStack(spacing: 0) {
                    SettingsToggleRow(title: "Sound", isOn: $settings.soundEnabled)
                    rowDivider
                    SettingsToggleRow(title: "Haptics", isOn: $settings.hapticsEnabled)
                    rowDivider
                    SettingsToggleRow(title: "Grid", isOn: $settings.gridEnabled)
                }
                .retroPanel()
                .padding(.horizontal, 22)

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
                .padding(.horizontal, 22)

                Spacer()

                PixelButton(title: "BACK", action: router.showMenu)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
            }
        }
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

private extension View {
    func retroPanel() -> some View {
        background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(GamePalette.buttonDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(GamePalette.buttonBorder, lineWidth: 1)
                )
        )
    }
}
