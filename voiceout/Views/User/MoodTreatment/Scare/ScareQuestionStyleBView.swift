//
//  ScareQuestionStyleBView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/26/25.
//

import SwiftUI

struct ScareQuestionStyleBView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    let onConfirm: (_ selectedOptions: [MoodTreatmentAnswerOption]) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var selectedOptions: Set<UUID> = []
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
                            ForEach(question.options.filter { $0.exclusive != true }, id: \.id) { option in
                                let isSelected = selectedOptions.contains(option.id)
                                HStack {
                                    Spacer()
                                    Button {
                                        if isSelected {
                                            selectedOptions.remove(option.id)
                                        } else {
                                            selectedOptions.insert(option.id)
                                        }
                                        onSelect(option)
                                    } label: {
                                        let imageName = isSelected ? "bottle-option-selected" : "bottle-option-normal"
                                        let caps = EdgeInsets(top: ViewSpacing.base, leading: ViewSpacing.xsmall+ViewSpacing.large, bottom: ViewSpacing.betweenSmallAndBase, trailing: ViewSpacing.xsmall+ViewSpacing.large)

                                        Text(option.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.grey500)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.leading, ViewSpacing.small)
                                            .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                                            .background(
                                                Image(imageName)
                                                    .resizable(capInsets: caps, resizingMode: .stretch)
                                            )
                                            .fixedSize(horizontal: false, vertical: true)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            if let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                                HStack {
                                    Spacer()
                                    Button {
                                        let selected = question.options
                                            .filter { $0.exclusive != true }
                                            .filter { selectedOptions.contains($0.id) }
                                        onConfirm(selected)
                                    } label: {
                                        Text(confirmOption.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.textBrandPrimary)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.vertical, ViewSpacing.small)
                                            .frame(height: 44)
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(CornerRadius.full.value)
                                    }
                                    .disabled(selectedOptions.isEmpty)
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
}

#Preview {
    ScareQuestionStyleBView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 45,
            uiStyle: .scareStyleB,
            texts: ["在外面的世界，感觉有点不踏实是很正常",
                    "我们先寻找一些可以让我们安心的东西，来帮助我们安心：你有注意到哪些让你熟悉或者安心的东西吗？"],
            animation: nil,
            options: [
                .init(key: "A",text: "我以前来过这里", next: nil, exclusive: false),
                .init(key: "B",text: "看到了熟悉的标志", next: nil, exclusive: false),
                .init(key: "C",text: "周围的人群看起来很正常", next: nil, exclusive: false),
                .init(key: "D",text: "看见了可爱的小动物", next: nil, exclusive: false),
                .init(key: "E",text: "闻到了美食的味道", next: nil, exclusive: false),
                .init(key: "F",text: "环境比较平静", next: nil, exclusive: false),
                .init(key: "G",text: "我选好了", next: nil, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        ),
        onSelect: { option in},
        onConfirm: { selected in}
    )
}
