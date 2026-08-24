import SwiftUI

enum GamePalette {
    static let background = Color(hex: 0x080F14)
    static let screenGreen = Color(hex: 0xA2F17D)
    static let snakeGreen = Color(hex: 0x7CFF5A)
    static let accentGreen = Color(hex: 0x00FF88)
    static let foodRed = Color(hex: 0xFF4D4D)
    static let textLight = Color(hex: 0xE6FFE6)
    static let buttonDark = Color(hex: 0x1C1F26)
    static let buttonBorder = Color(hex: 0x2E333D)

    static let lcdWell = Color(hex: 0x07140C)
    static let lcdBezel = Color(hex: 0x12181C)
    static let lcdHighlight = Color(hex: 0x2A333C)
    static let snakeHead = Color(hex: 0xD4FFB0)
    static let snakeShadow = Color(hex: 0x3D8A2E)
    static let gridDot = Color(hex: 0xA2F17D).opacity(0.16)
    static let overlayScrim = Color.black.opacity(0.88)
    static let danger = Color(hex: 0xFF4D4D)
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

enum Brand {
    static let company = "Sai Laksha Technologies"
    static let studio = "Sreeo"
    static let studioFull = "Sreeo Studio"
    static let appName = "Snakelet"
    static let tagline = "A retro arcade classic"
    static let supportEmail = "sreedharlakshmanan4@gmail.com"
    static let marketingURL = URL(string: "https://sreedharlakshman2.github.io")!
    static let supportURL = URL(string: "https://sreedharlakshman2.github.io/snake/")!
    static let privacyURL = URL(string: "https://sreedharlakshman2.github.io/snake/privacy.html")!
    static let tiles: [Color] = [
        Color(hex: 0x5CE1FF),
        Color(hex: 0xC084FC),
        Color(hex: 0xFB7185),
        Color(hex: 0xFBBF24)
    ]

    static var copyrightYear: Int {
        Calendar.current.component(.year, from: .now)
    }

    static var copyrightLine: String {
        "© \(copyrightYear) \(company)"
    }
}

extension View {
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
