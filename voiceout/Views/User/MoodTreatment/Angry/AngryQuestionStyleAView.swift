//
//  AngryQuestionStyleAView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/14/25.
//

import SwiftUI

struct AngryQuestionStyleAView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false

    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5

    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71

    var body: some View {
        GeometryReader { proxy in
            let safeTop = proxy.safeAreaInsets.top
            let texts = question.texts ?? []

            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea(edges: .bottom)

                Button { isPlayingMusic.toggle() } label: {
                    Image(isPlayingMusic ? "music" : "stop-music")
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                .padding(.leading, 16)

                VStack {
                    Spacer()
                    Image("bucket")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }

                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 71)
                            .scaleEffect(x: -1, y: 1)
                            .offset(x: -16)
                            .frame(width: 68)

                        BubbleScrollView(
                            texts: texts,
                            displayedCount: $displayedCount,
                            bubbleHeight: $bubbleHeight,
                            bubbleSpacing: 24,
                            //maxVisible: Int.max,
                            totalHeight: bubbleFrameHeight
                        )
                        .frame(height: bubbleFrameHeight)

                        Spacer()
                    }

                    if showOptions {
                        VStack(spacing: 8) {
                            ForEach(question.options) { option in
                                HStack {
                                    Spacer()
                                    if option.exclusive == true {
                                        Button { onSelect(option) } label: {
                                            HStack(spacing: 4) {
                                                Image("ai-star")
                                                    .frame(width: 24, height: 24)
                                                Text(option.text)
                                            }
                                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(360)
                                        }
                                    } else {
                                        Button { onSelect(option) } label: {
                                            Text(option.text)
                                                .font(Font.typography(.bodyMedium))
                                                .foregroundColor(.grey500)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(Color.surfacePrimary)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .inset(by: 2)
                                                        .stroke(Color(red: 0.42, green: 0.81, blue: 0.95),
                                                                lineWidth: 4)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 40)
                        .padding(.trailing, 16)
                        .transition(.opacity)
                    }

                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
            .onAppear { startBubbleSequence() }
        }
    }

    private func startBubbleSequence() {
        guard let texts = question.texts else { return }
        for idx in texts.indices {
            let delay = Double(idx) * (displayDuration + animationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    displayedCount += 1
                }
                if idx == texts.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeIn) {
                            showOptions = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AngryQuestionStyleAView(
        question: MoodTreatmentQuestion(
            id: 1,
            type: .singleChoice,
            uiStyle: .styleA,
            texts: [
                "可以告诉我，你现在感觉有多愤怒吗？",
                "小云朵感受到了你现在有些心情不好，",
                "我想要试着帮帮你呀。"
            ],
            animation: nil,
            options: [
                .init(text: "我只是感到轻微的生气或烦躁", next: 2, exclusive: false),
                .init(text: "我感到愤怒，但是仍在自己的可控范围内", next: 3, exclusive: false),
                .init(text: "我非常愤怒，情绪已经影响了日常生活", next: 10, exclusive: false)

            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil
        ),
        onSelect: { _ in }
    )
}


// 有 exclusive，没有“上一题”
//#Preview {
//    AngryQuestionStyleAView(
//        question: MoodTreatmentQuestion(
//            id: 2,
//            type: .singleChoice,
//            uiStyle: .styleA,
//            texts:["这段关系本身是否就是让你产生愤怒情绪的源头呢？","请记住，不要重复陷入一个负面循环中~"],
//            animation: nil,
//            options: [
//                .init(text: "明白了，我想做出改变~可以结束疏导", next: 4, exclusive: false),
//                .init(text: "我不知道怎么脱离", next: 5, exclusive: true)
//            ],
//            introTexts: nil
//        ),
//        onSelect: { _ in }
//    )
//}

