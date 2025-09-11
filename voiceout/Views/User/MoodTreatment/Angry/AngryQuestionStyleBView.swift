//
//  AngryQuestionStyleBView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/18/25.
//

import SwiftUI

struct AngryQuestionStyleBView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic: Bool = true
    @State private var showIntro: Bool = false
    @State private var showButton: Bool = false
    
    private let questionTypingInterval: TimeInterval = 0.1
    private let highlightTypingInterval: TimeInterval = 0.1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .frame(width:168,height: 120)
                                .padding(.bottom, 24)
                            Spacer()
                        }
                        
                        HStack {
                            Button {
                                isPlayingMusic.toggle()
                            } label: {
                                Image(isPlayingMusic ? "music" : "stop-music")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading, 16)
                    
                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()), id: \.offset) { idx, line in
//                        TypewriterText(
//                            fullText: line,
//                            characterDelay: questionTypingInterval
//                        ) {
//                            if idx == (question.texts?.count ?? 0) - 1 {
//                                showIntro = true
//                            }
//                        }
                        
                        TypewriterText(
                          fullText: line,
                          characterDelay: questionTypingInterval
                        ) {
                          if idx == (question.texts?.count ?? 0) - 1 {
                            if let highlights = question.introTexts, !highlights.isEmpty {
                              showIntro = true
                            } else {
                              showButton = true
                            }
                          }
                        }
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 64)
                        .padding(.bottom, 16)
                    }
                    
                    if showIntro, let highlights = question.introTexts {
                        ForEach(Array(highlights.enumerated()), id: \.offset) { idx, hl in
                            TypewriterText(
                                fullText: hl,
                                characterDelay: highlightTypingInterval
                            ) {
                                if idx == highlights.count - 1 {
                                    showButton = true
                                }
                            }
                            .font(Font.typography(.bodyMediumEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textBrandPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 64)
                            .padding(.bottom, 24)
                        }
                    }
                    
                    Spacer()
                    
                    if showButton,
                       let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                        Button(action: {
                            onSelect(confirmOption)
                        }) {
                            Text(confirmOption.text)
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                                .frame(width: 114, height: 44)
                                .background(Color.surfacePrimary)
                                .cornerRadius(360)
                        }
                        .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct AngryQuestionStyleBView_Previews: PreviewProvider {
    static var previews: some View {
        AngryQuestionStyleBView(
            question: MoodTreatmentQuestion(
                id: 4,
                type: .singleChoice,
                uiStyle: .styleB,
                texts: [
                    "接下来我们做一组简单的情绪疏导练习，这能够使你的潜意识感受到安全的信号"
                ],
                animation: nil,
                options: [
                    .init(text: "我准备好了", next: 5, exclusive: true)
                ],
                introTexts: [
                    "如果你愿意的话，可以先进入一个安全的环境里"
                ],
                showSlider: nil,
                endingStyle: nil
            ),
            onSelect: { _ in }
        )
    }
}
