import SwiftUI

struct PressablePixelStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct PixelButton: View {
    let title: String
    var isPrimary: Bool = false
    var isDisabled: Bool = false
    var systemImage: String? = nil
    let action: () -> Void

    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        Button(action: trigger) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .tracking(1.4)
            }
            .foregroundColor(foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(border, lineWidth: isPrimary ? 0 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: isPrimary && !isDisabled ? GamePalette.accentGreen.opacity(0.28) : .clear, radius: 12, y: 0)
        }
        .buttonStyle(PressablePixelStyle())
        .disabled(isDisabled)
        .accessibilityLabel(title)
        .accessibilityHint(isPrimary ? "Starts a new game" : "Opens \(title.lowercased())")
    }

    private var foreground: Color {
        isPrimary ? GamePalette.background : GamePalette.textLight
    }

    private var background: Color {
        isPrimary ? GamePalette.screenGreen : GamePalette.buttonDark
    }

    private var border: Color {
        isPrimary ? Color.clear : GamePalette.buttonBorder
    }

    private func trigger() {
        guard !isDisabled else { return }
        HapticManager.shared.buttonPress(enabled: settings.hapticsEnabled)
        SoundManager.shared.playButton(enabled: settings.soundEnabled)
        action()
    }
}
