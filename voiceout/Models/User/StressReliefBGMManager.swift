//
//  StressReliefBGMManager.swift
//  voiceout
//
//  Created by Yujia Yang on 8/8/25.
//

import AVFoundation

final class StressReliefBGMManager {
    static let shared = StressReliefBGMManager()
    private var player: AVAudioPlayer?
    private var fadeTimer: Timer?

    private init() {}

    func playGardenIfNeeded() {
        prepareIfNeeded()
        guard let p = player else { return }
        if !p.isPlaying { p.play() }
    }

    func pause() {
        player?.pause()
    }

    func resume() {
        prepareIfNeeded()
        player?.play()
    }

    func fade(to volume: Float, duration: TimeInterval = 0.4) {
        guard duration > 0 else { player?.volume = volume; return }
        fadeTimer?.invalidate()
        let start = player?.volume ?? 1.0
        let delta = volume - start
        let steps = max(1, Int(duration / 0.03))
        var step = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] t in
            guard let self = self else { t.invalidate(); return }
            step += 1
            let p = min(1.0, Float(step) / Float(steps))
            self.player?.volume = start + delta * p
            if step >= steps {
                t.invalidate()
                self.player?.volume = volume
            }
        }
        if let timer = fadeTimer { RunLoop.main.add(timer, forMode: .common) }
    }

    func fadeOutAndPause(duration: TimeInterval = 0.4) {
        fade(to: 0.0, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.pause()
        }
    }

    func fadeInAndResume(duration: TimeInterval = 0.4) {
        if player?.isPlaying != true { resume() }
        fade(to: 1.0, duration: duration)
    }

    private func prepareIfNeeded() {
        guard player == nil else { return }
        guard let url = Bundle.main.url(forResource: "garden", withExtension: "mp3") else {
            print("garden.mp3 not found")
            return
        }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1
            p.volume = 1.0
            p.prepareToPlay()
            player = p
        } catch {
            print("BGM prepare error: \(error)")
        }
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}
