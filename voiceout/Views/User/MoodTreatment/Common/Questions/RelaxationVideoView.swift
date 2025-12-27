//
//  RelaxationVideoView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/31/25.
//

import SwiftUI
import AVKit
import UIKit

extension RelaxationVideoView {
    init(name: String, ext: String = "mp4") {
        self.question = MoodTreatmentQuestion(
            id: -999,
            totalQuestions: nil,
            uiStyle: .styleIntensificationVideo,
            texts: nil,
            animation: ext.isEmpty ? name : "\(name).\(ext)",
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: nil
        )
        self.onSelect = nil
    }
}

struct RelaxationVideoView: View {
    @EnvironmentObject var router: RouterModel
    let question: MoodTreatmentQuestion
    var onSelect: ((MoodTreatmentAnswerOption) -> Void)? = nil
    @State private var player: AVPlayer?
    @State private var timeObserver: Any?
    @State private var boundaryObserver: Any?
    @State private var showDoneButton = false
    @State private var showExitPopup = false

    var body: some View {
        ZStack {
            PlayerView(player: player)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button { skipToEnd() } label: {
                        Text("跳过")
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.xsmall)
                    .background(.white.opacity(0.5))
                    .cornerRadius(CornerRadius.full.value)
                }
                .padding(.horizontal, ViewSpacing.medium)

                Spacer()

                if showDoneButton {
                    Button { handleDone() } label: {
                        Text(question.buttonTitle.isEmpty ? "完成" : question.buttonTitle)
                            .font(Font.typography(.bodyMedium))
                            .kerning(0.64)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                            .frame(maxWidth: 240, minHeight: 44)
                            .background(Color.surfacePrimary)
                            .clipShape(Capsule())
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding(.bottom, 2*ViewSpacing.betweenSmallAndBase+ViewSpacing.xxxsmall+ViewSpacing.xlarge)
                }
            }
        }
        .overlay {
            ZStack {
                if showExitPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    ExitPopupCardView(
                        onExit: {
                            hidePopup()
                            router.navigateTo(.mainHomepage)
                        },
                        onContinue: { hidePopup() },
                        onClose: { hidePopup() }
                    )
                    .padding(.horizontal, ViewSpacing.xlarge)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.32, dampingFraction: 0.86), value: showExitPopup)
        }
        .onAppear { setupAndPlay() }
        .onDisappear { cleanup() }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func handleDone() {
        if let nextOption = question.options.first(where: { $0.exclusive == true }) {
            if let onSelect {
                onSelect(nextOption)
            } else {
                router.navigateBack()
            }
            return
        }
        router.navigateBack()
    }
    
    private func setupAndPlay() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .moviePlayback)
            try session.setActive(true)
        } catch {
            print("Audio session error:", error)
        }
        player = makePlayerFromQuestion()
        guard let player else { return }

        player.actionAtItemEnd = .pause

        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { _ in
            guard let item = player.currentItem, item.duration.isNumeric else { return }

            if boundaryObserver == nil {
                let hold = endHoldTime(for: item)
                boundaryObserver = player.addBoundaryTimeObserver(
                    forTimes: [NSValue(time: hold)],
                    queue: .main
                ) {
                    player.seek(to: hold, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                        player.pause()
                        player.currentItem?.step(byCount: 0)
                        withAnimation { showDoneButton = true }
                    }
                    if let bo = boundaryObserver {
                        player.removeTimeObserver(bo)
                        boundaryObserver = nil
                    }
                }
            }

            if let obs = timeObserver {
                player.removeTimeObserver(obs)
                timeObserver = nil
            }
        }

        player.play()
    }

    private func makePlayerFromQuestion() -> AVPlayer? {
        let raw = (question.animation ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://"),
           let url = URL(string: raw) {
            return AVPlayer(url: url)
        }

        let (name, ext) = splitNameAndExt(raw, defaultExt: "mp4")
        if !name.isEmpty, let url = Bundle.main.url(forResource: name, withExtension: ext) {
            return AVPlayer(url: url)
        }

        if let url = Bundle.main.url(forResource: "relax", withExtension: "mp4") {
            return AVPlayer(url: url)
        }

        return nil
    }

    private func splitNameAndExt(_ raw: String, defaultExt: String) -> (String, String) {
        guard !raw.isEmpty else { return ("", defaultExt) }
        if let dot = raw.lastIndex(of: ".") {
            let name = String(raw[..<dot])
            let ext = String(raw[raw.index(after: dot)...])
            return (name, ext.isEmpty ? defaultExt : ext)
        }
        return (raw, defaultExt)
    }

    private func cleanup() {
        player?.pause()
        if let obs = timeObserver {
            player?.removeTimeObserver(obs)
            timeObserver = nil
        }
        if let bo = boundaryObserver {
            player?.removeTimeObserver(bo)
            boundaryObserver = nil
        }
    }

    private func hidePopup() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            showExitPopup = false
        }
    }

    private func skipToEnd() {
        guard let player, let item = player.currentItem else { return }
        let hold = endHoldTime(for: item)

        player.seek(to: hold, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            player.pause()
            player.currentItem?.step(byCount: 0)
            if let bo = boundaryObserver {
                player.removeTimeObserver(bo)
                boundaryObserver = nil
            }
            withAnimation { showDoneButton = true }
        }
    }

    private func endHoldTime(for item: AVPlayerItem) -> CMTime {
        let duration = item.duration
        guard duration.isNumeric else { return duration }

        if let track = item.asset.tracks(withMediaType: .video).first,
           track.nominalFrameRate > 0 {
            let frame = 1.0 / Double(track.nominalFrameRate)
            let eps   = max(frame * 1.5, 0.12)
            let t     = max(CMTimeGetSeconds(duration) - eps, 0)
            return CMTime(seconds: t, preferredTimescale: duration.timescale)
        } else {
            let t = max(CMTimeGetSeconds(duration) - 0.15, 0)
            return CMTime(seconds: t, preferredTimescale: duration.timescale)
        }
    }
}

private struct PlayerView: UIViewRepresentable {
    let player: AVPlayer?

    func makeUIView(context: Context) -> PlayerContainer {
        let v = PlayerContainer()
        v.backgroundColor = .black
        v.playerLayer.player = player
        v.playerLayer.videoGravity = .resizeAspectFill
        return v
    }

    func updateUIView(_ uiView: PlayerContainer, context: Context) {
        uiView.playerLayer.player = player
    }

    final class PlayerContainer: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }
}

#Preview {
    RelaxationVideoView(
        question: MoodTreatmentQuestion(
            id: 1001,
            totalQuestions: 45,
            uiStyle: .styleIntensificationVideo,
            texts: nil,
            animation: "relax",
            options: [
                .init(key: "A", text: "继续", next: 2002, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        )
    )
    .environmentObject(RouterModel())
}
