//
//  EnvyEndingView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/1/25.
//

import SwiftUI

struct EnvyEndingView: View {
    let question: MoodTreatmentQuestion

    @State private var animationDone = false
    @State private var isPlayingMusic = true

    var body: some View {
        GeometryReader { geo in
            let bubbleInsets = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

            ZStack(alignment: .topLeading) {
                moodColors["envy"]!
                    .ignoresSafeArea()

                if !animationDone {
                    LottieView(
                        animationName: "angry-end",
                        loopMode: .playOnce,
                        autoPlay: true,
                        onFinished: { animationDone = true },
                        speed: 0.2
                    )
                    .frame(width: geo.size.width, height: geo.size.height * 0.9)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
                }

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, 16)
                        Spacer()
                    }
                    .padding(.top, geo.safeAreaInsets.top)

                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(question.texts ?? [], id: \.self) { line in
                                Text(line)
                                    .font(.typography(.bodyMedium))
                                    .foregroundColor(.grey500)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .padding(.bottom, 10)
                        .background(
                            Image("bubble-union1")
                                .resizable(capInsets: bubbleInsets, resizingMode: .stretch)
                        )
                        .frame(maxWidth: geo.size.width * 0.6, alignment: .leading)

                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .offset(y:80)
                    }
                    .padding(.trailing, -100)
                    .padding(.top, 24)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}


#Preview {
    EnvyEndingView(
        question: MoodTreatmentQuestion(
            id: 999,
            type: .custom,
            uiStyle: .styleEnvyEnding,
            texts: [
                "愿你像小云朵一样，每天找到新的美好，装满自己的小天空。"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            customViewName: nil
        )
    )
    .environmentObject(RouterModel())
}
