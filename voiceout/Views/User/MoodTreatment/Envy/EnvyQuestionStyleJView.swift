//
//  EnvyQuestionStyleJView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/30/25.
//

import SwiftUI

struct EnvyQuestionStyleJView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic: Bool = true
    @State private var showButton: Bool = false
    
    private let questionTypingInterval: TimeInterval = 0.1
    
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
                                .resizable()
                                .frame(width:168, height:120)
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
                    
                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()),
                            id: \.offset) { idx, line in
                        TypewriterText(
                            fullText: line,
                            characterDelay: questionTypingInterval
                        ) {
                            if idx == (question.texts?.count ?? 1) - 1 {
                                showButton = true
                            }
                        }
                        .font(.typography(.bodyMedium))
                        .frame( alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.grey500)
                        .padding(.horizontal, 64)
                    }
                    
                    Spacer()
                    
                    if showButton, let option = question.options.first {
                        Button(action: {
                            onSelect(option)
                        }){
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
                        .transition(.opacity)
                    }
                    Spacer(minLength: 300)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct EnvyQuestionStyleJView_Previews: PreviewProvider {
    static var previews: some View {
        EnvyQuestionStyleJView(
            question: MoodTreatmentQuestion(
                id: 4,
                type: .singleChoice,
                uiStyle: .styleJ,
                texts: ["你可以简单说说，你怎么看待ta？你最关注ta的哪些方面？"],
                animation: nil,
                options: [
                    .init(text: "试试和小云聊聊天", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: nil,
                endingStyle: nil
            )
        ) { selected in
            print("按钮回调：", selected)
        }
    }
}

