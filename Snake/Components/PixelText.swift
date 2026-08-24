import SwiftUI

struct PixelText: View {
    let text: String
    var size: CGFloat = 6
    var weight: Font.Weight = .regular
    var color: Color = GamePalette.screenGreen
    var glow: Bool = false
    var maxWidth: CGFloat?

    var body: some View {
        let pixel = scaledPixelSize
        HStack(alignment: .top, spacing: pixel) {
            ForEach(Array(normalized.enumerated()), id: \.offset) { _, character in
                PixelGlyph(character: character, pixelSize: pixel, color: color, bold: weight != .regular)
            }
        }
        .shadow(color: glow ? color.opacity(0.55) : .clear, radius: glow ? size * 0.8 : 0)
        .accessibilityLabel(text)
    }

    private var normalized: String {
        text.uppercased()
    }

    private var scaledPixelSize: CGFloat {
        guard let maxWidth, maxWidth > 0 else { return size }
        let columns = PixelFont.columnCount(for: normalized)
        guard columns > 0 else { return size }
        return min(size, floor(maxWidth / CGFloat(columns)))
    }
}

private struct PixelGlyph: View {
    let character: Character
    let pixelSize: CGFloat
    let color: Color
    let bold: Bool

    var body: some View {
        let rows = PixelFont.pattern(for: character)
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<rows.count, id: \.self) { row in
                HStack(spacing: 0) {
                    let cells = Array(rows[row])
                    ForEach(0..<5, id: \.self) { column in
                        let glyph = column < cells.count ? cells[column] : "0"
                        let lit = glyph == "1" || glyph == "#"
                        Rectangle()
                            .fill(lit ? color : Color.clear)
                            .frame(width: pixelSize + (bold && lit ? 0.4 : 0), height: pixelSize)
                    }
                }
            }
        }
        .frame(width: pixelSize * 5, height: pixelSize * 7, alignment: .topLeading)
    }
}

enum PixelFont {
    static func columnCount(for text: String) -> Int {
        guard !text.isEmpty else { return 0 }
        return text.count * 6 - 1
    }

    static func pattern(for character: Character) -> [String] {
        glyphs[character] ?? glyphs["?"] ?? Array(repeating: "00000", count: 7)
    }

    private static let glyphs: [Character: [String]] = [
        "A": ["01110", "10001", "10001", "11111", "10001", "10001", "10001"],
        "B": ["11110", "10001", "10001", "11110", "10001", "10001", "11110"],
        "C": ["01110", "10001", "10000", "10000", "10000", "10001", "01110"],
        "D": ["11110", "10001", "10001", "10001", "10001", "10001", "11110"],
        "E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
        "F": ["11111", "10000", "10000", "11110", "10000", "10000", "10000"],
        "G": ["01110", "10001", "10000", "10111", "10001", "10001", "01111"],
        "H": ["10001", "10001", "10001", "11111", "10001", "10001", "10001"],
        "I": ["11111", "00100", "00100", "00100", "00100", "00100", "11111"],
        "J": ["00111", "00001", "00001", "00001", "00001", "10001", "01110"],
        "K": ["10001", "10010", "10100", "11000", "10100", "10010", "10001"],
        "L": ["10000", "10000", "10000", "10000", "10000", "10000", "11111"],
        "M": ["10001", "11011", "10101", "10101", "10001", "10001", "10001"],
        "N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
        "O": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
        "P": ["11110", "10001", "10001", "11110", "10000", "10000", "10000"],
        "Q": ["01110", "10001", "10001", "10001", "10101", "10010", "01101"],
        "R": ["11110", "10001", "10001", "11110", "10100", "10010", "10001"],
        "S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
        "T": ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
        "U": ["10001", "10001", "10001", "10001", "10001", "10001", "01110"],
        "V": ["10001", "10001", "10001", "10001", "10001", "01010", "00100"],
        "W": ["10001", "10001", "10001", "10101", "10101", "10101", "01010"],
        "X": ["10001", "10001", "01010", "00100", "01010", "10001", "10001"],
        "Y": ["10001", "10001", "01010", "00100", "00100", "00100", "00100"],
        "Z": ["11111", "00001", "00010", "00100", "01000", "10000", "11111"],
        "0": ["01110", "10001", "10011", "10101", "11001", "10001", "01110"],
        "1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
        "2": ["01110", "10001", "00001", "00110", "01000", "10000", "11111"],
        "3": ["11110", "00001", "00001", "01110", "00001", "00001", "11110"],
        "4": ["00010", "00110", "01010", "10010", "11111", "00010", "00010"],
        "5": ["11111", "10000", "11110", "00001", "00001", "10001", "01110"],
        "6": ["01110", "10000", "10000", "11110", "10001", "10001", "01110"],
        "7": ["11111", "00001", "00010", "00100", "01000", "01000", "01000"],
        "8": ["01110", "10001", "10001", "01110", "10001", "10001", "01110"],
        "9": ["01110", "10001", "10001", "01111", "00001", "00001", "01110"],
        " ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],
        ".": ["00000", "00000", "00000", "00000", "00000", "00100", "00100"],
        ":": ["00000", "00100", "00100", "00000", "00100", "00100", "00000"],
        "!": ["00100", "00100", "00100", "00100", "00100", "00000", "00100"],
        "?": ["01110", "10001", "00001", "00010", "00100", "00000", "00100"],
        "-": ["00000", "00000", "00000", "11111", "00000", "00000", "00000"],
        "/": ["00001", "00010", "00010", "00100", "01000", "01000", "10000"]
    ]
}
