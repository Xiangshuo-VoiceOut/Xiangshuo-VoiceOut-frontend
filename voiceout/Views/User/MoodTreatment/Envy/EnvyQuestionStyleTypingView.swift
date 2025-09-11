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

    private let typingInterval: TimeInterval = 0.1

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
                                .padding(.bottom, 24)
                            Spacer()
                        }
                        
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, 16)
                    }

                    VStack(spacing: 8) {
                        ForEach(question.texts ?? [], id: \.self) { line in
                            if !introDone {
                                TypewriterText(fullText: line, characterDelay: typingInterval) {
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
                    .padding(.horizontal, 64)
                    .padding(.top, 24)

                    if introDone {
                        VStack(spacing: 16) {
                            ZStack(alignment: .topLeading) {
                                if inputText.isEmpty {
                                    Text("我已经尽了最大努力，今天对自己宽容一点。")
                                        .font(.typography(.bodyLarge))
                                        .foregroundColor(.textLight)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 24)
                                }
                                TextEditor(text: $inputText)
                                    .font(.typography(.bodyLarge))
                                    .foregroundColor(.textPrimary)
                                    .padding(12)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                            }
                            .frame(height: 139)
                            .background(Color.surfacePrimary)
                            .cornerRadius(16)
                            .padding(.horizontal, 32)

                            if let btnOpt = exclusiveOption, !inputText.isEmpty {
                                Button(action: {
                                    let answer = MoodTreatmentAnswerOption(
                                        text: inputText,
                                        next: btnOpt.next,
                                        exclusive: true
                                    )
                                    onSelect(answer)
                                }) {
                                    Text(btnOpt.text)
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(height: 44)
                                        .background(Color.surfacePrimary)
                                        .cornerRadius(360)
                                }
                                .padding(.top, 22)
                            }
                        }
                        .padding(.top, 40)
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
            type: .singleChoice,
            uiStyle: .styleTyping,
            texts: [
                "在我们感到脆弱和敏感的时候，可能是我们的内心需要更多的关爱。现在，可以跟我一起写下这几句话～"
            ],
            animation: nil,
            options: [
                .init(text: "我写好了", next: nil, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil
        ),
        onSelect: { answer in
            print("用户写下：", answer.text)
        }
    )
}
