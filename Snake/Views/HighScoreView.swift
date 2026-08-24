import SwiftUI

struct HighScoreView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var scores: [HighScoreEntry] = []
    @State private var lastID: UUID?

    var body: some View {
        ZStack {
            RetroBackdrop()

            VStack(spacing: 24) {
                PixelText(text: "HIGH SCORE", size: 7, weight: .bold, color: GamePalette.screenGreen, glow: true)
                    .padding(.top, 18)

                VStack(spacing: 0) {
                    if scores.isEmpty {
                        Text("NO SCORES YET")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundColor(GamePalette.textLight.opacity(0.55))
                            .frame(maxWidth: .infinity, minHeight: 180)
                    } else {
                        ForEach(Array(scores.enumerated()), id: \.element.id) { index, entry in
                            HighScoreRow(
                                rank: index + 1,
                                entry: entry,
                                highlighted: entry.id == lastID
                            )
                            if index < scores.count - 1 {
                                Rectangle()
                                    .fill(GamePalette.buttonBorder.opacity(0.6))
                                    .frame(height: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(GamePalette.lcdWell.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(GamePalette.screenGreen.opacity(0.18), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 22)

                Spacer()

                PixelButton(title: "BACK", action: router.showMenu)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
            }
        }
        .onAppear {
            let manager = HighScoreManager.shared
            scores = manager.loadTopScores()
            lastID = manager.lastSubmittedID()
        }
    }
}

private struct HighScoreRow: View {
    let rank: Int
    let entry: HighScoreEntry
    let highlighted: Bool

    var body: some View {
        HStack {
            Text(String(format: "%d.", rank))
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundColor(highlighted ? GamePalette.accentGreen : GamePalette.screenGreen.opacity(0.7))
                .frame(width: 28, alignment: .leading)

            Text(entry.name)
                .font(.system(size: 15, weight: highlighted ? .bold : .semibold, design: .monospaced))
                .foregroundColor(highlighted ? GamePalette.snakeHead : GamePalette.textLight)

            Spacer()

            Text("\(entry.score)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(highlighted ? GamePalette.screenGreen : GamePalette.textLight)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(highlighted ? GamePalette.accentGreen.opacity(0.08) : Color.clear)
        .accessibilityLabel("Rank \(rank), \(entry.name), \(entry.score) points")
    }
}
