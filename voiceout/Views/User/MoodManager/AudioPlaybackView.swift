//
//  AudioPlaybackView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/16/25.
//

import SwiftUI
import AVFoundation

struct AudioPlaybackView: View {
    var voiceUrl: String
    var localFileUrl: URL? = nil
    @Binding var isVisible: Bool

    @State private var isPlaying = false
    @State private var player: AVAudioPlayer?

    var body: some View {
        if isVisible {
            HStack(alignment: .center, spacing: 0) {
                Text(LocalizedStringKey("audio_file"))
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textBrandPrimary)
                    .frame(height: 60, alignment: .center)
                
                Spacer()
                
                Button(action: {
                    if isPlaying {
                        player?.pause()
                        isPlaying = false
                    } else {
                        playAudio()
                    }
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.surfaceBrandPrimary)
                        Image("polygon")
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(ViewSpacing.medium)
            .background(Color.surfaceBrandTertiaryGreen)
            .cornerRadius(CornerRadius.medium.value)
            .padding(.horizontal, ViewSpacing.small)
            .imageShadow()
        }
    }

    private func playAudio() {
        guard let url = resolveAudioURL() else {
            print("Invalid audio path")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            isPlaying = true

            print("Play the audio: \(url)")
        } catch {
            print("Failed to play: \(error.localizedDescription)")
        }
    }

    private func resolveAudioURL() -> URL? {
        if let local = localFileUrl, FileManager.default.fileExists(atPath: local.path) {
            return local
        }

        if voiceUrl.hasPrefix("file://"), let fileUrl = URL(string: voiceUrl), FileManager.default.fileExists(atPath: fileUrl.path) {
            return fileUrl
        }

        return nil
    }
}

#Preview {
    AudioPlaybackView(
        voiceUrl: "file://dummy/path/to/audio.m4a",
        localFileUrl: nil,
        isVisible: .constant(true)
        )
}
