//
//  EnvyQuestionStyleTypingView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/1/25.
//

import SwiftUI

struct EnvyQuestionStyleTypingView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var inputText: String = ""
    @State private var isPlayingMusic = true
    @State private var introDone = false

    private var exclusiveOption: MoodTreatmentAnswerOption? {
        question.options.first { $0.exclusive == true}
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        MusicButtonView()
                            .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.small) {
                        ForEach(question.texts ?? [], id: \.self) { line in
                            if !introDone {
                                TypewriterText(fullText: line) {
                                    if line == question.texts?.last {
                                        introDone = true
                                    }
                                }
                            } else {
                                Text(line)
                            }
                        }
                    }
                    .font(.typography(.bodyMedium))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.grey500)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.top, ViewSpacing.large)

                    if introDone {
                        VStack(spacing: ViewSpacing.medium) {
                            ZStack(alignment: .topLeading) {
                                if inputText.isEmpty {
                                    Text("我已经尽了最大努力，今天对自己宽容一点。")
                                        .font(.typography(.bodyLarge))
                                        .foregroundColor(.textLight)
                                        .padding(.horizontal, ViewSpacing.medium)
                                        .padding(.vertical, ViewSpacing.large)
                                }
                                TextEditor(text: $inputText)
                                    .font(.typography(.bodyLarge))
                                    .foregroundColor(.textPrimary)
                                    .padding(ViewSpacing.base)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                            }
                            .frame(height: 139)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            .padding(.horizontal, ViewSpacing.xlarge)

                            if let btnOpt = exclusiveOption, !inputText.isEmpty {
                                Button(action: {
                                    let answer = MoodTreatmentAnswerOption(
                                        key: btnOpt.key ?? "DONE",
                                        text: inputText,
                                        next: btnOpt.next,
                                        exclusive: true
                                    )
                                    onSelect(answer)
                                }) {
                                    Text(btnOpt.text)
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                        .padding(.horizontal, ViewSpacing.medium)
                                        .padding(.vertical, ViewSpacing.small)
                                        .frame(height: 44)
                                        .background(Color.surfacePrimary)
                                        .cornerRadius(CornerRadius.full.value)
                                }
                                .padding(.top, ViewSpacing.base+ViewSpacing.betweenSmallAndBase)
                            }
                        }
                        .padding(.top, ViewSpacing.medium+ViewSpacing.large)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    EnvyQuestionStyleTypingView(
        question: MoodTreatmentQuestion(
            id: 4,
            totalQuestions: 100,
            uiStyle: .styleTyping,
            texts: [
                "在我们感到脆弱和敏感的时候，可能是我们的内心需要更多的关爱。现在，可以跟我一起写下这几句话～"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "我写好了", next: nil, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "envy"
        ),
        onSelect: { _ in }
    )
}
