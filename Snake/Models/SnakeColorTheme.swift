import SwiftUI

enum SnakeColorTheme: String, CaseIterable, Identifiable {
    case classic
    case neon
    case amber
    case azure
    case violet
    case gold
    case rose
    case ice

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classic: return "Classic"
        case .neon: return "Neon"
        case .amber: return "Amber"
        case .azure: return "Azure"
        case .violet: return "Violet"
        case .gold: return "Gold"
        case .rose: return "Rose"
        case .ice: return "Ice"
        }
    }

    var body: Color {
        switch self {
        case .classic: return Color(hex: 0x7CFF5A)
        case .neon: return Color(hex: 0x22D3EE)
        case .amber: return Color(hex: 0xFBBF24)
        case .azure: return Color(hex: 0x60A5FA)
        case .violet: return Color(hex: 0xC084FC)
        case .gold: return Color(hex: 0xEAB308)
        case .rose: return Color(hex: 0xFB7185)
        case .ice: return Color(hex: 0xE2E8F0)
        }
    }

    var head: Color {
        switch self {
        case .classic: return Color(hex: 0xD4FFB0)
        case .neon: return Color(hex: 0xCFFAFE)
        case .amber: return Color(hex: 0xFEF3C7)
        case .azure: return Color(hex: 0xDBEAFE)
        case .violet: return Color(hex: 0xF3E8FF)
        case .gold: return Color(hex: 0xFEF9C3)
        case .rose: return Color(hex: 0xFFE4E6)
        case .ice: return Color(hex: 0xFFFFFF)
        }
    }

    var shadow: Color {
        switch self {
        case .classic: return Color(hex: 0x3D8A2E)
        case .neon: return Color(hex: 0x0E7490)
        case .amber: return Color(hex: 0xB45309)
        case .azure: return Color(hex: 0x1D4ED8)
        case .violet: return Color(hex: 0x6D28D9)
        case .gold: return Color(hex: 0xA16207)
        case .rose: return Color(hex: 0xBE123C)
        case .ice: return Color(hex: 0x64748B)
        }
    }
}
