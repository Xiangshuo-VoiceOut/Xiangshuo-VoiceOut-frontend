//
//  ScareQuestionStyleAView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/26/25.
//

import SwiftUI

struct ScareQuestionStyleAView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false
    @State private var selectedId: UUID? = nil

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

                MusicButtonView()
                    .padding(.leading, ViewSpacing.medium)

                VStack {
                    Spacer()
                    Image("bottle-bee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 238, height: 209)
                        .padding(.horizontal,ViewSpacing.xxxsmall+ViewSpacing.small+ViewSpacing.betweenSmallAndBase+ViewSpacing.xxlarge)
                }

                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 71)
                            .scaleEffect(x: -1, y: 1)
                            .offset(x: -ViewSpacing.medium)
                            .frame(width: 68)

                        BubbleScrollView(
                            texts: texts,
                            displayedCount: $displayedCount,
                            bubbleHeight: $bubbleHeight,
                            bubbleSpacing: ViewSpacing.large,
                            totalHeight: bubbleFrameHeight
                        )
                        .frame(height: bubbleFrameHeight)

                        Spacer()
                    }

                    if showOptions {
                        VStack(spacing: ViewSpacing.small) {
                            ForEach(question.options, id: \..id) { option in
                                HStack {
                                    Spacer()
                                    optionButton(option: option)
                                }
                            }
                        }
                        .padding(.top, ViewSpacing.medium+ViewSpacing.large)
                        .padding(.trailing, ViewSpacing.medium)
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

    @ViewBuilder
    private func optionButton(option: MoodTreatmentAnswerOption) -> some View {
        let isSelected = selectedId == option.id
        let capInsets = EdgeInsets(top: 12, leading: 28, bottom: 12, trailing: 28)
        let imageName = isSelected ? "bottle-option-selected" : "bottle-option-normal"

        Text(option.text)
            .font(Font.typography(.bodyMedium))
            .foregroundColor(.grey500)
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.leading, ViewSpacing.small)
            .padding(.vertical, ViewSpacing.base)
            .background(
                Image(imageName)
                    .resizable(capInsets: capInsets, resizingMode: .stretch)
            )
            .fixedSize(horizontal: false, vertical: true)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedId = option.id
                onSelect(option)
            }
    }
}

#Preview {
    ScareQuestionStyleAView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            type: .singleChoice,
            uiStyle: .scareStyleA,
            texts: [
                "现在，请感受一下自己的状态。",
                "你是否觉得自己正处于危险之中？"
            ],
            animation: nil,
            options: [
                .init(key: "A",text: "是的，我感到了不安全", next: 2, exclusive: false),
                .init(key: "B",text: "没有，我目前觉得自己是安全的", next: 3, exclusive: false)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        ),
        onSelect: { _ in }
    )
}
