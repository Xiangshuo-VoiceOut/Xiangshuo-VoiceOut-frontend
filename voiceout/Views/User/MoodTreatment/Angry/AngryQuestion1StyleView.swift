//
//  AngryQuestion1StyleView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/14/25.
//

import SwiftUI

struct AngryQuestion1StyleView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @EnvironmentObject private var router: RouterModel
    
    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false
    
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
                
                Button { isPlayingMusic.toggle() } label: {
                    Image(isPlayingMusic ? "music" : "stop-music")
                        .resizable()
                        .frame(width: 48, height: 48)
                }
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
                                    Spacer()
                                    Button { handleTap(option) } label: {
                                        Text(option.text)
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.grey500)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.vertical, ViewSpacing.base)
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .inset(by: 2)
                                                    .stroke(Color(red: 0.42, green: 0.81, blue: 0.95),
                                                            lineWidth: 4)
                                            )
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
    
    private func handleTap(_ option: MoodTreatmentAnswerOption) {
        if question.routine == "anger",
           question.id == 1,
           option.key == "C" {
            router.navigateTo(.stressReliefEntry)
            return
        }
        onSelect(option)
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
    AngryQuestion1StyleView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            type: .custom,
            uiStyle: .styleA,
            texts: [
                "可以告诉我，你现在感觉有多愤怒吗？",
                "小云朵感受到了你现在有些心情不好，",
                "我想要试着帮帮你呀。"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "我只是感到轻微的生气或烦躁", next: 2,  exclusive: false),
                .init(key: "B", text: "我感到愤怒，但是仍在自己的可控范围内", next: 3,  exclusive: false),
                .init(key: "C", text: "我非常愤怒，情绪已经影响了日常生活",   next: 10, exclusive: false)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        ),
        onSelect: { _ in }
    )
    .environmentObject(RouterModel())
}
