import SwiftUI

struct FoodRenderer: View {
    let position: GridPosition
    let cellSize: CGFloat
    var pulse: Bool = false
    var fruit: FruitKind = .apple

    var body: some View {
        PixelFruit(kind: fruit)
            .frame(width: cellSize * 0.82, height: cellSize * 0.82)
            .scaleEffect(pulse ? 1.28 : 1)
            .position(
                x: CGFloat(position.x) * cellSize + cellSize / 2,
                y: CGFloat(position.y) * cellSize + cellSize / 2
            )
            .shadow(color: fruit.glowColor.opacity(0.45), radius: pulse ? 8 : 3)
            .animation(.spring(response: 0.22, dampingFraction: 0.55), value: pulse)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct PixelFruit: View {
    let kind: FruitKind

    var body: some View {
        Canvas { context, size in
            let rows = FruitPixels.rows(for: kind)
            let cols = rows.first?.count ?? 1
            let unit = min(size.width / CGFloat(cols), size.height / CGFloat(rows.count))
            let offsetX = (size.width - unit * CGFloat(cols)) / 2
            let offsetY = (size.height - unit * CGFloat(rows.count)) / 2

            for (row, line) in rows.enumerated() {
                for (column, code) in line.enumerated() {
                    guard let color = FruitPixels.color(code, kind: kind) else { continue }
                    let rect = CGRect(
                        x: offsetX + CGFloat(column) * unit,
                        y: offsetY + CGFloat(row) * unit,
                        width: unit,
                        height: unit
                    )
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .accessibilityHidden(true)
    }
}

private enum FruitPixels {
    static func rows(for kind: FruitKind) -> [String] {
        switch kind {
        case .apple:
            return [
                "..G....",
                "...LL..",
                ".RRRRR.",
                "RRRRRRR",
                "RRWRRRR",
                ".RRRRR.",
                "..RRR.."
            ]
        case .cherry:
            return [
                "..GG.G.",
                ".G..G..",
                "RR..CC.",
                "RRR.CCC",
                "RRR.CCC",
                ".R...C.",
                "......."
            ]
        case .banana:
            return [
                "....YY.",
                "...YYY.",
                "..YYYY.",
                ".YYYYK.",
                "YYYY...",
                ".YY....",
                "......."
            ]
        case .orange:
            return [
                "...G...",
                "..LLL..",
                ".OOOOO.",
                "OOOOOOO",
                "OOWOOOO",
                ".OOOOO.",
                "..OOO.."
            ]
        case .grape:
            return [
                "...G...",
                "..PPP..",
                ".PPPPP.",
                "PPPPPPP",
                ".PPPPP.",
                "..PPP..",
                "...P..."
            ]
        case .strawberry:
            return [
                "..GGG..",
                ".RRRRR.",
                "RRYRRYR",
                "RYRRYRR",
                ".RRYRR.",
                "..RRR..",
                "...R..."
            ]
        case .watermelon:
            return [
                "..DDD..",
                ".DMMMD.",
                "DMMKMMD",
                "DMKMKMD",
                ".DMMMD.",
                "..DDD..",
                "......."
            ]
        case .blueberry:
            return [
                "...N...",
                "..NNN..",
                ".NNNNN.",
                "NNWNNNN",
                ".NNNNN.",
                "..NNN..",
                "......."
            ]
        }
    }

    static func color(_ code: Character, kind: FruitKind) -> Color? {
        switch code {
        case "R": return Color(hex: 0xFF4D4D)
        case "C": return Color(hex: 0xBE123C)
        case "Y": return Color(hex: 0xFBBF24)
        case "K": return Color(hex: 0x1C1917)
        case "O": return Color(hex: 0xFB923C)
        case "P": return Color(hex: 0xA855F7)
        case "L": return Color(hex: 0x4ADE80)
        case "G": return GamePalette.screenGreen
        case "W": return Color.white.opacity(0.55)
        case "D": return Color(hex: 0x16A34A)
        case "M": return Color(hex: 0xFB7185)
        case "N": return Color(hex: 0x3B82F6)
        case ".": return nil
        default:
            return kind.glowColor
        }
    }
}
