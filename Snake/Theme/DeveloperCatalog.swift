import SwiftUI

struct DeveloperApp: Identifiable {
    let id: String
    let name: String
    let blurb: String
    let symbol: String
    let tint: Color

    var storeURL: URL {
        URL(string: "https://apps.apple.com/app/id\(id)")!
    }
}

enum DeveloperCatalog {
    static let storePage = URL(string: "https://apps.apple.com/developer/id1677299144")!

    static let apps: [DeveloperApp] = [
        DeveloperApp(
            id: "6448906516",
            name: "Count Mantras",
            blurb: "Japa mala of 108, streaks, and stotras",
            symbol: "sparkles",
            tint: Color(hex: 0xEAB308)
        ),
        DeveloperApp(
            id: "6446448645",
            name: "Speedy Meter",
            blurb: "Live GPS speed, trip distance, and map",
            symbol: "speedometer",
            tint: Color(hex: 0x22D3EE)
        ),
        DeveloperApp(
            id: "6446313196",
            name: "Kolour Pencil",
            blurb: "Draw, write, and share in seconds",
            symbol: "pencil.tip",
            tint: Color(hex: 0xFB7185)
        ),
        DeveloperApp(
            id: "6802272622",
            name: "Coin Toss",
            blurb: "Fair 3D coin flip with country coins",
            symbol: "circle.lefthalf.filled",
            tint: Color(hex: 0xFBBF24)
        ),
        DeveloperApp(
            id: "6802367964",
            name: "Space Explorer",
            blurb: "Planets, missions, and astronaut academy",
            symbol: "sparkle",
            tint: Color(hex: 0x818CF8)
        ),
        DeveloperApp(
            id: "6800885773",
            name: "Sreeo Games",
            blurb: "Blocks and Balloon Pop for families",
            symbol: "gamecontroller.fill",
            tint: Color(hex: 0x34D399)
        ),
        DeveloperApp(
            id: "6801934819",
            name: "On Earth Recap",
            blurb: "Private weekly map of where you went",
            symbol: "globe.americas.fill",
            tint: Color(hex: 0x38BDF8)
        ),
        DeveloperApp(
            id: "6802106645",
            name: "Story Beads",
            blurb: "Stories and counting beads for kids",
            symbol: "book.fill",
            tint: Color(hex: 0xC084FC)
        ),
        DeveloperApp(
            id: "6447702559",
            name: "Rock Paper Scissors",
            blurb: "Quick rounds with music and score",
            symbol: "hand.raised.fill",
            tint: Color(hex: 0xF97316)
        )
    ]
}
