import SwiftUI

enum FruitKind: String, CaseIterable, Identifiable {
    case apple
    case cherry
    case banana
    case orange
    case grape
    case strawberry
    case watermelon
    case blueberry

    var id: String { rawValue }

    var title: String {
        switch self {
        case .apple: return "Apple"
        case .cherry: return "Cherry"
        case .banana: return "Banana"
        case .orange: return "Orange"
        case .grape: return "Grape"
        case .strawberry: return "Berry"
        case .watermelon: return "Melon"
        case .blueberry: return "Blue"
        }
    }

    var glowColor: Color {
        switch self {
        case .apple: return Color(hex: 0xFF4D4D)
        case .cherry: return Color(hex: 0xE11D48)
        case .banana: return Color(hex: 0xFBBF24)
        case .orange: return Color(hex: 0xFB923C)
        case .grape: return Color(hex: 0xA855F7)
        case .strawberry: return Color(hex: 0xF43F5E)
        case .watermelon: return Color(hex: 0xFB7185)
        case .blueberry: return Color(hex: 0x3B82F6)
        }
    }
}
