//
//  AngryQuestionStyleEView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/4/25.
//

import SwiftUI

struct AngryQuestionStyleEView: View {
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

    @State private var selectedKey: String? = nil
    private let selectionHold: TimeInterval = 0.15
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
                                                    ? Color(red: 0.42, green: 0.81, blue: 0.95)
                                                    : Color.surfacePrimary
                                            )
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .inset(by: 2)
                                                    .stroke(Color(red: 0.42, green: 0.81, blue: 0.95), lineWidth: 4)
                                            )
                                    }
                                }

                                if let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                                    Button {
                                        let selected = question.options
                                            .filter { $0.exclusive != true }
                                            .filter { selectedOptions.contains($0.id) }
                                        onConfirm(selected)
                                    } label: {
                                        Text(confirmOption.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
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
    AngryQuestionStyleEView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 45,
            uiStyle: .styleE,
            texts: ["小云朵明白了~","如果你现在感到愤怒，可以告诉我身体是否出现了下列这些变化吗？（多选）"],
            animation: nil,
            options: [
                .init(key: "A",text: "肌肉处于紧绷状态", next: nil, exclusive: false),
                .init(key: "B",text: "脸颊变红、体温升高、内部像要爆炸", next: nil, exclusive: false),
                .init(key: "C",text: "无法控制的流泪", next: nil, exclusive: false),
                .init(key: "D",text: "牙齿咬紧，或攥紧拳头", next: nil, exclusive: false),
                .init(key: "E",text: "想要扔东西、砸墙，或者伤害某些人事物", next: nil, exclusive: false),
                .init(key: "F",text: "其实，我现在没有这些感觉", next: 101, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        ),
        onSelect: { option in
        },
        onConfirm: { selected in
        }
    )
}
