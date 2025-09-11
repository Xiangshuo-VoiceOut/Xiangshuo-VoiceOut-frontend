//
//  EnvyQuestionStyleIView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/28/25.
//

import SwiftUI

struct EnvyQuestionStyleIView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    let onConfirm: (_ selectedOptions: [MoodTreatmentAnswerOption]) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var selectedOptions: Set<UUID> = []
    @State private var showOptions = false
    @State private var bubbleHeight: CGFloat = 0

    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5
    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71

    private var nonConfirmOptions: [MoodTreatmentAnswerOption] {
        question.options.filter { $0.exclusive == false }
    }

    private var confirmOption: MoodTreatmentAnswerOption? {
        question.options.first { $0.exclusive == true }
    }

    var body: some View {
        GeometryReader { proxy in
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
                    Image("mirror")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 48)
                        .padding(.bottom, 16)
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
                            totalHeight: bubbleFrameHeight
                        )
                        .frame(height: bubbleFrameHeight)

                        Spacer()
                    }

                    if showOptions {
                        HStack(spacing: 8) {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 8) {
                                ForEach(nonConfirmOptions) { option in
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
                                            .font(.typography(.bodyMedium))
                                            .foregroundColor(.grey500)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(isSelected
                                                        ? Color(red: 0.42, green: 0.81, blue: 0.95)
                                                        : Color.surfacePrimary
                                            )
                                            .overlay(
                                                Rectangle()
                                                    .inset(by: 2)
                                                    .stroke(Color(red: 0.86, green: 0.65, blue: 0.38), lineWidth: 4)
                                                    .shadow(color: Color(red: 0.54, green: 0.28, blue: 0.32),
                                                            radius: 0, x: 2, y: 2)
                                            )
                                    }
                                }

                                if let confirmOpt = confirmOption {
                                    Button {
                                        let selected = nonConfirmOptions.filter { selectedOptions.contains($0.id) }
                                        onConfirm(selected)
                                    } label: {
                                        Text(confirmOpt.text)
                                            .font(.typography(.bodyMedium))
                                            .kerning(0.64)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.textBrandPrimary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .frame(height: 44)
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(360)
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 40)
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
                        withAnimation(.easeIn) { showOptions = true }
                    }
                }
            }
        }
    }
}

#Preview {
    EnvyQuestionStyleIView(
        question: MoodTreatmentQuestion(
            id: 3,
            type: .multiChoice,
            uiStyle: .styleI,
            texts: ["可以跟小云朵说说你是因为什么而感到嫉妒的吗？"],
            animation: nil,
            options: [
                .init(text: "我没有别人的外貌，身材", next: nil, exclusive: false),
                .init(text: "家庭不够优越", next: nil, exclusive: false),
                .init(text: "我没有一技之长", next: nil, exclusive: false),
                .init(text: "别人能力更强", next: nil, exclusive: false),
                .init(text: "如果有别人的一半幸运就好了", next: nil, exclusive: false),
                .init(text: "在群体里不受欢迎", next: nil, exclusive: false),
                .init(text: "其它", next: nil, exclusive: false),
                .init(text: "我选好了", next: nil, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil
        ),
        onSelect: { _ in },
        onConfirm: { selected in print("确认：", selected.map { $0.text }) }
    )
}
