//
//  ScareEndingView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/15/25.
//

import SwiftUI

struct ScareEndingView: View {
    let question: MoodTreatmentQuestion

    @State private var animationDone = false
    @State private var isPlayingMusic = true

    var body: some View {
        let bubbleInsets = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        ZStack(alignment: .topLeading) {
            moodColors["scare"]!
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    MusicButtonView().padding(.leading, ViewSpacing.medium)
                    Spacer()
                }
                .padding(.top, ViewSpacing.small)

                HStack(alignment: .top, spacing: ViewSpacing.small) {
                    VStack(alignment: .leading, spacing: ViewSpacing.small) {
                        ForEach(question.texts ?? [], id: \.self) { line in
                            Text(line)
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.base)
                    .padding(.bottom, ViewSpacing.betweenSmallAndBase)
                    .background(
                        Image("bubble-union1")
                            .resizable(capInsets: bubbleInsets, resizingMode: .stretch)
                    )
                    .frame(maxWidth: 280, alignment: .leading)

                    Image("cloud-chat")
                        .resizable()
                        .frame(width: 100, height: 71)
                        .padding(.top, 6*ViewSpacing.betweenSmallAndBase)
                        .offset(x: 20)
                }
                .padding(.leading, ViewSpacing.medium)
                .padding(.top, ViewSpacing.large)

                LottieView(
                    animationName: "scare-end",
                    loopMode: .loop,
                    autoPlay: true,
                    onFinished: { animationDone = true },
                    speed: 0.5
                )
                .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    let scareEndings = [
        "你做得太好了，小云朵看见你一步步走出害怕的阴影，真的替你感到骄傲！如果愿意的话，可以在情绪日历上记下今天是勇敢的一天哦~",
        "看，小害怕云慢慢变成了一朵软软的棉花糖云，心里是不是也暖暖的？以后再遇到类似的情绪，我们也可以这么温柔地照顾它。",
        "你真的很棒，能够察觉害怕、面对它，再一点点让它变小，这就是勇气的样子呢。小云朵为你鼓掌~",
        "害怕并不代表软弱，它只是想告诉你：“嘿，有些事我还没准备好。”你能静静听见它的声音，就是一种了不起的力量。"
    ]
    let randomEnding = scareEndings.randomElement()!

    ScareEndingView(
        question: MoodTreatmentQuestion(
            id: 999,
            totalQuestions: 45,
            type: .custom,
            uiStyle: .scareStyleEnding,
            texts: [randomEnding],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            customViewName: nil,
            routine: "scare"
        )
    )
    .environmentObject(RouterModel())
}
