import AVFoundation
import Foundation

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    private var players: [AVAudioPlayer] = []
    private var didConfigureSession = false

    private init() {}

    func prepare() {
        configureSessionIfNeeded()
    }

    func playButton(enabled: Bool) {
        play(enabled: enabled, frequency: 620, duration: 0.045, volume: 0.18)
    }

    func playEat(enabled: Bool) {
        play(enabled: enabled, frequency: 880, duration: 0.07, volume: 0.28)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) { [weak self] in
            self?.play(enabled: enabled, frequency: 1240, duration: 0.06, volume: 0.22)
        }
    }

    func playGameOver(enabled: Bool) {
        play(enabled: enabled, frequency: 220, duration: 0.18, volume: 0.32)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) { [weak self] in
            self?.play(enabled: enabled, frequency: 140, duration: 0.22, volume: 0.28)
        }
    }

    func playWin(enabled: Bool) {
        play(enabled: enabled, frequency: 660, duration: 0.08, volume: 0.24)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.09) { [weak self] in
            self?.play(enabled: enabled, frequency: 880, duration: 0.10, volume: 0.24)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { [weak self] in
            self?.play(enabled: enabled, frequency: 1175, duration: 0.16, volume: 0.26)
        }
    }

    // MARK: - Synthesis

    private func configureSessionIfNeeded() {
        guard !didConfigureSession else { return }
        didConfigureSession = true
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            // Sound is optional; failing closed keeps the game playable.
        }
    }

    private func play(enabled: Bool, frequency: Double, duration: Double, volume: Float) {
        guard enabled else { return }
        configureSessionIfNeeded()
        guard let data = Self.squareWave(frequency: frequency, duration: duration),
              let player = try? AVAudioPlayer(data: data) else { return }
        player.volume = volume
        player.prepareToPlay()
        players.append(player)
        player.play()
        if players.count > 6 {
            players.removeFirst(players.count - 6)
        }
    }

    private static func squareWave(frequency: Double, duration: Double, sampleRate: Double = 22050) -> Data? {
        let sampleCount = Int(duration * sampleRate)
        guard sampleCount > 0 else { return nil }

        var samples = [Int16](repeating: 0, count: sampleCount)
        let period = sampleRate / frequency
        for index in 0..<sampleCount {
            let envelope: Double
            let fade = min(0.012, duration / 4)
            let time = Double(index) / sampleRate
            if time < fade {
                envelope = time / fade
            } else if time > duration - fade {
                envelope = max(0, (duration - time) / fade)
            } else {
                envelope = 1
            }
            let phase = Double(index).truncatingRemainder(dividingBy: period)
            let value = phase < period / 2 ? 1.0 : -1.0
            samples[index] = Int16(max(-1, min(1, value * envelope)) * 18_000)
        }

        return wavData(samples: samples, sampleRate: UInt32(sampleRate))
    }

    private static func wavData(samples: [Int16], sampleRate: UInt32) -> Data {
        let dataSize = UInt32(samples.count * 2)
        var data = Data()
        func appendASCII(_ value: String) {
            data.append(contentsOf: value.utf8)
        }
        func appendU32(_ value: UInt32) {
            var little = value.littleEndian
            data.append(Data(bytes: &little, count: 4))
        }
        func appendU16(_ value: UInt16) {
            var little = value.littleEndian
            data.append(Data(bytes: &little, count: 2))
        }

        appendASCII("RIFF")
        appendU32(36 + dataSize)
        appendASCII("WAVE")
        appendASCII("fmt ")
        appendU32(16)
        appendU16(1)
        appendU16(1)
        appendU32(sampleRate)
        appendU32(sampleRate * 2)
        appendU16(2)
        appendU16(16)
        appendASCII("data")
        appendU32(dataSize)
        samples.withUnsafeBytes { buffer in
            data.append(contentsOf: buffer)
        }
        return data
    }
}
