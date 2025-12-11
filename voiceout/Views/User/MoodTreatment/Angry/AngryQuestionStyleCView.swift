//
//  AngryQuestionStyleCView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/3/25.
//

import SwiftUI

struct AngryQuestionStyleCView: View {
    let question: MoodTreatmentQuestion
    
    @State private var isPlayingMusic = true
    @State private var completedLines = 0
    
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
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        HStack {
                            MusicButtonView()
                            Spacer()
                        }
                    }
                    .padding(.leading, ViewSpacing.medium)
                    
                    VStack(spacing:0){
                        if let lines = question.texts {
                            ForEach(Array(lines.enumerated()), id: \.offset) { idx, line in
                                TypewriterText(fullText: line) {
                                    completedLines += 1
                                }
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 2*ViewSpacing.xlarge)
                            }
                        }
                        
                        if completedLines == question.texts?.count,
                           let animationName = question.animation {
                            LottieView(
                                animationName: animationName,
                                loopMode: .playOnce,
                                speed: 0.5
                            )
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.height * 0.7
                            )
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

#Preview {
    AngryQuestionStyleCView(
        question: MoodTreatmentQuestion(
            id: 999,
            totalQuestions: 45,
            uiStyle: .styleC,
            texts: [
                "让我们先闭上眼睛深呼吸，每次吸气和呼气都要超过5秒。请不要担心时间，1分钟后，我会负责提醒你的~"
            ],
            animation: "bubble-breaking",
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        )
    )
}
