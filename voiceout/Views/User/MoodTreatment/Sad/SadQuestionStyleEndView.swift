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
//                musicButton
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
        Color(red: 0.659, green: 0.843, blue: 0.969)
            .ignoresSafeArea(edges: .bottom)
    }
    
//    private var musicButton: some View {
//        Button { isPlayingMusic.toggle() } label: {
//            Image(isPlayingMusic ? "music" : "stop-music")
//                .resizable()
//                .frame(width: 48, height: 48)
//        }
//        .padding(.leading, ViewSpacing.medium)
//    }
    
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
            chatBubbleSection(texts: texts)
            
            ZStack {
                VStack(spacing: ViewSpacing.medium) {
                    Spacer()
                    sadAndRainSection
                    Spacer()
                }
                .frame(maxHeight: 200)
                
                if showWindEffect {
                    WindEffectView(offset: windOffset)
                        .onAppear {
                            windOffset = -200
                            withAnimation(.easeInOut(duration: 2.0)) {
                                windOffset = UIScreen.main.bounds.width + 200
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    cloudOpacity = 0.0
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showHappyCloud = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            showHappyText = true
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            onContinue()
                                        }
                                    }
                                }
                            }
                        }
                }
            }
            
            
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
            
            BubbleScrollView(
                texts: showHappyText ? ["难过已经被你温柔地安放好了，是不是感觉轻松了一点呢？就像夜晚终会迎来晨曦，希望也会一点一点填满你的心。小云朵给你一个温柔的拥抱~"] : texts,
                displayedCount: $displayedCount,
                bubbleHeight: $bubbleHeight,
                bubbleSpacing: ViewSpacing.large,
                totalHeight: bubbleFrameHeight
            )
            .frame(height: bubbleFrameHeight)
            
            Spacer()
        }
    }
    
    private var sadAndRainSection: some View {
        ZStack {
            Image("sad")
                .resizable()
                .scaledToFit()
                .frame(width: 216, height: 154)
                .padding(.horizontal, ViewSpacing.xxxsmall)
                .padding(.vertical, ViewSpacing.xsmall+ViewSpacing.medium)
                .opacity(cloudOpacity)
            
            if showHappyCloud {
                Image("happycloud")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 216, height: 154)
                    .padding(.horizontal, ViewSpacing.xxxsmall)
                    .padding(.vertical, ViewSpacing.xsmall+ViewSpacing.medium)
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

struct WindEffectView: View {
    let offset: CGFloat
    
    var body: some View {
        Image("sadwind")
            .resizable()
            .scaledToFit()
        .frame(width: 200, height: 100)
        .offset(x: offset)
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
