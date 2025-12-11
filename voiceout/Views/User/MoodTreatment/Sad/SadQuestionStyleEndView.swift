//
//  SadQuestionStyleEndView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/26/25.
//

import SwiftUI

struct SadQuestionStyleEndView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showWindEffect = false
    @State private var windOffset: CGFloat = -200
    @State private var cloudOpacity: Double = 1.0
    @State private var showHappyCloud = false
    @State private var showHappyText = false

    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5

    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71

    var body: some View {
        GeometryReader { proxy in
            let _ = proxy.safeAreaInsets.top
            let texts = question.texts ?? []

            ZStack(alignment: .topLeading) {
                backgroundView
                musicButton
                windmillBackground
                mainContent(texts: texts)
            }
            .ignoresSafeArea(edges: .all)
            .onAppear { startBubbleSequence() }
            .onLongPressGesture(minimumDuration: 0.5) {
                showWindEffect = true
            }
        }
    }
    
    private var backgroundView: some View {
        Color(red: 0.659, green: 0.843, blue: 0.969) // #A8D7F7
            .ignoresSafeArea(edges: .bottom)
    }
    
    private var musicButton: some View {
        Button { isPlayingMusic.toggle() } label: {
            Image(isPlayingMusic ? "music" : "stop-music")
                .resizable()
                .frame(width: 48, height: 48)
        }
        .padding(.leading, ViewSpacing.medium)
    }
    
    private var windmillBackground: some View {
        VStack {
            Spacer()
            Image("windmill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func mainContent(texts: [String]) -> some View {
        VStack(spacing: 0) {
            // 对话部分
            chatBubbleSection(texts: texts)
            
            // 中间区域：sadcloud、happycloud、wind效果
            ZStack {
                VStack(spacing: ViewSpacing.medium) {
                    Spacer()
                    sadAndRainSection
                    Spacer()
                }
                .frame(maxHeight: 200) // 限制中间区域高度
                
                // 风效果在中间区域
                if showWindEffect {
                    WindEffectView(offset: windOffset)
                        .onAppear {
                            // 从左边开始
                            windOffset = -200
                            // 移动到右边
                            withAnimation(.easeInOut(duration: 2.0)) {
                                windOffset = UIScreen.main.bounds.width + 200
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    cloudOpacity = 0.0
                                }
                                
                                // sad云朵消失后显示happycloud
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showHappyCloud = true
                                    }
                                    
                                    // happy cloud出现后显示新文本
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            showHappyText = true
                                        }
                                        
                                        // 再等3秒后进入下一题
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            onContinue()
                                        }
                                    }
                                }
                            }
                        }
                }
            }
            
            // 底部留出空间给风车
            Spacer(minLength: 150)
        }
        .padding(.top, ViewSpacing.large)
    }
    
    private func chatBubbleSection(texts: [String]) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("cloud-chat")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 71)
                .scaleEffect(x: -1, y: 1)
                .offset(x: -ViewSpacing.medium)
                .frame(width: 68)
            
            // 使用BubbleScrollView，根据showHappyText状态显示不同文本
            BubbleScrollView(
                texts: showHappyText ? ["难过已经被你温柔地安放好了，是不是感觉轻松了一点呢？就像夜晚终会迎来晨曦，希望也会一点一点填满你的心。小云朵给你一个温柔的拥抱~"] : texts,
                displayedCount: $displayedCount,
                bubbleHeight: $bubbleHeight,
                bubbleSpacing: 24,
                totalHeight: bubbleFrameHeight
            )
            .frame(height: bubbleFrameHeight)
            
            Spacer()
        }
    }
    
    private var sadAndRainSection: some View {
        ZStack {
            // sad cloud
            Image("sad")
                .resizable()
                .scaledToFit()
                .frame(width: 216, height: 154.286) // 根据提供的数据
                .padding(.horizontal, 1.08)
                .padding(.vertical, 19.98)
                .opacity(cloudOpacity)
            
            // happycloud在sad云朵消失后出现，在同一个位置
            if showHappyCloud {
                Image("happycloud")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 216, height: 154.286)
                    .padding(.horizontal, 1.08)
                    .padding(.vertical, 19.98)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func startBubbleSequence() {
        guard let texts = question.texts, !texts.isEmpty else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                displayedCount = question.texts?.count ?? 0
            }
        }
    }
}

// 风效果视图
struct WindEffectView: View {
    let offset: CGFloat
    
    var body: some View {
        Image("sadwind")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 100)
            .offset(x: offset) // 移除y偏移，因为现在在中间区域
    }
}

#Preview {
    SadQuestionStyleEndView(
        question: MoodTreatmentQuestion(
            id: 12,
            totalQuestions: 12,
            uiStyle: .styleEnd,
            texts: ["你已经收集足够多的风啦，长按屏幕帮助小云朵吧！"],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}