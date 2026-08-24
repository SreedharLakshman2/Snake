import SwiftUI

struct EatParticle: Identifiable, Equatable {
    let id: Int
    let origin: GridPosition
    let angle: Double
    let createdAt: Date
}

struct ParticleBurst: View {
    let particles: [EatParticle]
    let cellSize: CGFloat

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: particles.isEmpty)) { timeline in
            Canvas { context, _ in
                for particle in particles {
                    let age = timeline.date.timeIntervalSince(particle.createdAt)
                    guard age < 0.38 else { continue }
                    let progress = age / 0.38
                    let distance = cellSize * (0.4 + progress * 1.4)
                    let x = CGFloat(particle.origin.x) * cellSize + cellSize / 2 + CGFloat(cos(particle.angle)) * distance
                    let y = CGFloat(particle.origin.y) * cellSize + cellSize / 2 + CGFloat(sin(particle.angle)) * distance
                    let size = cellSize * 0.16 * (1 - progress)
                    let rect = CGRect(x: x - size / 2, y: y - size / 2, width: size, height: size)
                    context.opacity = 1 - progress
                    context.fill(Path(rect), with: .color(GamePalette.foodRed))
                }
            }
        }
        .allowsHitTesting(false)
    }
}
