//
//  EnvyQuestionStyleHView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/28/25.
//

import SwiftUI

struct EnvyQuestionStyleHView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
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
                
                Button { isPlayingMusic.toggle() } label: {
                    Image(isPlayingMusic ? "music" : "stop-music")
                        .resizable()
                        .frame(width: 48, height: 48)
                }
                .padding(.leading, ViewSpacing.medium)
                
                VStack {
                    Spacer()
                    Image("mirror")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,ViewSpacing.medium+ViewSpacing.xlarge)
                        .padding(.bottom,ViewSpacing.medium)
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
                            bubbleSpacing: 24,
                            totalHeight: bubbleFrameHeight
                        )
                        .frame(height: bubbleFrameHeight)
                        
                        Spacer()
                    }
                    
                    if showOptions {
                        VStack(spacing: ViewSpacing.small) {
                            ForEach(question.options) { option in
                                HStack {
                                    Spacer(minLength: 80)
                                    if option.exclusive == true {
                                        Button { onSelect(option) } label: {
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
                                    } else {
                                        Button {
                                            onSelect(option)
                                        } label: {
                                            Text(option.text)
                                                .font(Font.typography(.bodyMedium))
                                                .foregroundColor(.grey500)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, ViewSpacing.medium)
                                                .padding(.vertical, ViewSpacing.base)
                                                .background(Color.surfacePrimary)
                                                .overlay(
                                                    Rectangle()
                                                        .inset(by: 2)
                                                        .stroke(Color(red: 0.86, green: 0.65, blue: 0.38), lineWidth: 4)
                                                        .shadow(color: Color(red: 0.54, green: 0.28, blue: 0.32),
                                                                radius: 0, x: 2, y: 2)
                                                )
                                        }
                                    }
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
    EnvyQuestionStyleHView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 100,
            type: .singleChoice,
            uiStyle: .styleA,
            texts: [
                "可以跟小云朵说说你的嫉妒程度吗？"
            ],
            animation: nil,
            options: [
                .init(key: "A",text: "我心里已经产生了敌意，偏见，厌恶，甚至怨恨。已经开始在语言或行为上伤害对方", next: 2, exclusive: false),
                .init(key: "B",text: "产生内耗情绪，常想着与对方竞争比较，以此渴望证明自己", next: 3, exclusive: false),
                .init(key: "C",text: "轻微嫉妒。偶尔发生，并不放在心里。没有对别人产生偏见或采取行动影响对方", next: 10, exclusive: false)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "envy"
        ),
        onSelect: { _ in }
    )
}

