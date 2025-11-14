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
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        HStack {
                            MusicButtonView()
                            Spacer()
                        }
                    }
                    .padding(.leading, ViewSpacing.medium)
                    
                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()),
                            id: \.offset) { idx, line in
                        TypewriterText(
                            fullText: line
                        ) {
                            if idx == (question.texts?.count ?? 1) - 1 {
                                showButton = true
                            }
                        }
                        .font(.typography(.bodyMedium))
                        .frame( alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.grey500)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                    }
                    
                    Spacer()
                    
                    if showButton, let option = question.options.first {
                        Button(action: {
                            onSelect(option)
                        }){
                            HStack(spacing: ViewSpacing.xsmall) {
                                Image("ai-star")
                                    .frame(width: 24, height: 24)
                                Text(option.text)
                            }
                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.small)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.full.value)
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
                totalQuestions: 100,
                type: .singleChoice,
                uiStyle: .styleJ,
                texts: ["你可以简单说说，你怎么看待ta？你最关注ta的哪些方面？"],
                animation: nil,
                options: [
                    .init(key: "A",text: "试试和小云聊聊天", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: nil,
                endingStyle: nil,
                routine: "envy"
            )
        ) { selected in }
    }
}

