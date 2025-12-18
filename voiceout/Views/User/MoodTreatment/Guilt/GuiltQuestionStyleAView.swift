//
//  GuiltQuestionStyleAView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/8/25.
//

import SwiftUI

struct GuiltQuestionStyleAView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false

    @State private var selectedKey: String? = nil
    private let selectionHold: TimeInterval = 0.15

    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5
    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71

    var body: some View {
        GeometryReader { proxy in
            let _ = proxy.safeAreaInsets.top
            let texts = question.texts ?? []
            
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea(edges: .bottom)
                
                MusicButtonView()
                    .padding(.leading, ViewSpacing.medium)
                
                VStack {
                    Spacer()
                    VStack {
                        Image("body-flower-red")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 17*ViewSpacing.betweenSmallAndBase)
                        
                        Image("flower-basket")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 8*ViewSpacing.betweenSmallAndBase)
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
                        VStack(spacing: ViewSpacing.small) {
                            ForEach(question.options) { option in
                                let isSelected = (selectedKey == option.key)
                                HStack {
                                    Spacer()
                                    Button {
                                        guard selectedKey == nil else { return }
                                        withAnimation(.easeIn(duration: selectionHold)) {
                                            selectedKey = option.key
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + selectionHold) {
                                            onSelect(option)
                                            selectedKey = nil
                                        }
                                    } label: {
                                        Text(option.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.grey500)
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
                                    .disabled(selectedKey != nil)
                                }
                            }
                        }
                        .padding(.top, ViewSpacing.medium + ViewSpacing.large)
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
    GuiltQuestionStyleAView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            uiStyle: .guiltStyleA,
            texts: [
                "没事的，小云朵会一直陪着你～",
                "想和我说说，你是因为什么而感到内疚的呢？"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "感觉自己伤害了他人", next: 2,  exclusive: false),
                .init(key: "B", text: "没有达到对自己的要求", next: 3,  exclusive: false),
                .init(key: "C", text: "拒绝了别人的请求",   next: 10, exclusive: false),
                .init(key: "D", text: "做了自己不太满意的决定", next: 11, exclusive: false),
                .init(key: "E", text: "其他", next: 12, exclusive: false)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "guilt"
        ),
        onSelect: { _ in }
    )
}
