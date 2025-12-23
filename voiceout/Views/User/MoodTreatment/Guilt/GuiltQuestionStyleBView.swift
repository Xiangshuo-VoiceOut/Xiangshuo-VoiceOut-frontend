//
//  GuiltQuestionStyleBView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/9/25.
//

import SwiftUI

struct GuiltQuestionStyleBView: View {
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

//                MusicButtonView()
//                    .padding(.leading, ViewSpacing.medium)

                VStack {
                    Spacer()
                    VStack{
                        Image("body-flower-red")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal,17*ViewSpacing.betweenSmallAndBase)
                        
                        Image("flower-basket")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal,8*ViewSpacing.betweenSmallAndBase)
                    }
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
                        HStack(spacing: ViewSpacing.small) {
                            Spacer()
                            VStack(alignment: .trailing, spacing:ViewSpacing.small) {
                                ForEach(question.options.filter { $0.exclusive != true }) { option in
                                    let isSelected = selectedOptions.contains(option.id)
                                    Button {
                                        if isSelected {
                                            selectedOptions.remove(option.id)
                                        } else {
                                            selectedOptions.insert(option.id)
                                        }
                                        onSelect(option)
                                    } label: {
                                        Text(option.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.grey500)
                                            .multilineTextAlignment(.trailing)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.vertical, ViewSpacing.base)
                                            .background(
                                                isSelected
                                                    ? Color(red: 1, green: 0.91, blue: 0.85)
                                                    : Color.surfacePrimary
                                            )
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: CornerRadius.xsmall.value)
                                                    .inset(by: 2)
                                                    .stroke(Color(red: 0.86, green: 0.65, blue: 0.38), lineWidth: 4)
                                            )
                                    }
                                }

                                if let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                                    let isReady = !selectedOptions.isEmpty
                                    Button {
                                        let selected = question.options
                                            .filter { $0.exclusive != true }
                                            .filter { selectedOptions.contains($0.id) }
                                        onConfirm(selected)
                                    } label: {
                                        Text(confirmOption.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(isReady ? .textBrandPrimary : .textLight)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.vertical, ViewSpacing.small)
                                            .frame(height: 44)
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(CornerRadius.full.value)
                                    }
                                    .disabled(!isReady)
                                    .animation(.easeInOut(duration: 0.2), value: isReady)
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
    GuiltQuestionStyleBView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 45,
            uiStyle: .guiltStyleB,
            texts: ["只有随时保持中立和客观的观察，才能看到事情的全貌哦！","你在练习中做的很棒！","小云朵想问问，你是否能识别出当时自己最真实的情绪？"],
            animation: nil,
            options: [
                .init(key: "A",text: "委屈", next: nil, exclusive: false),
                .init(key: "B",text: "自责", next: nil, exclusive: false),
                .init(key: "C",text: "难过", next: nil, exclusive: false),
                .init(key: "D",text: "无力", next: nil, exclusive: false),
                .init(key: "E",text: "惊讶", next: nil, exclusive: false),
                .init(key: "F",text: "受伤", next: nil, exclusive: false),
                .init(key: "G",text: "自定义", next: nil, exclusive: false),
                .init(key: "H",text: "我选好了", next: 101, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "guilt"
        ),
        onSelect: { option in},
        onConfirm: { selected in}
    )
}
