//
//  SadQuestionStyleFillInBlankView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/21/25.
//

import SwiftUI

struct SadQuestionStyleFillInBlankView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var userInput = ""
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        return introTexts[0]
    }
    
    private var hasIntroText: Bool {
        return !currentIntroText.isEmpty
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
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
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                    // 打字完成后可以执行的操作
                                }
                                .id(currentTextIndex) // 添加key强制重新渲染
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // 直接显示填空区域
                        fillInBlankArea
                        
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.large)
                    
                    // 确认按钮 - 固定在底部
                    if !userInput.isEmpty {
                        Button("确认") {
                            onContinue()
                        }
                        .font(.typography(.bodyMedium))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, ViewSpacing.large)
                        .padding(.vertical, ViewSpacing.medium)
                        .background(Color(red: 0.404, green: 0.722, blue: 0.6))
                        .cornerRadius(CornerRadius.full.value)
                        .padding(.horizontal, ViewSpacing.large)
                        .padding(.bottom, ViewSpacing.large)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    
    private var fillInBlankArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            // introText
            if hasIntroText {
                TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                    // introtext打字完成后可以执行的操作
                }
                .id("intro-\(currentTextIndex)") // 添加key强制重新渲染
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6)) // #67B899
                .multilineTextAlignment(.center)
                .frame(width: 252, alignment: .center)
            }
            
            // 填空题文本
            VStack(spacing: ViewSpacing.small) {
                HStack(spacing: 0) {
                    Text("最想聊的是 ")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.textPrimary)
                    
                    TextField("怪奇物语的剧情/养生话题/茶道", text: $userInput)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.textPrimary)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(maxWidth: 150)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.surfacePrimary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .onChange(of: userInput) { _, newValue in
                            // 限制字数不超过15字
                            if newValue.count > 15 {
                                userInput = String(newValue.prefix(15))
                            }
                        }
                }
                .multilineTextAlignment(.center)
                
                // 提示文字
                Text("（字数不超过15字）")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private func handleContinue() {
        if currentTextIndex < (question.texts?.count ?? 0) - 1 {
            currentTextIndex += 1
            showCurrentText = true
        } else {
            onContinue()
        }
    }
}

#Preview {
    SadQuestionStyleFillInBlankView(
        question: MoodTreatmentQuestion(
            id: 7,
            totalQuestions: 10,
            type: .fillInBlank,
            uiStyle: .styleFillInBlank,
            texts: ["那在这些环境里，你最想聊的兴趣或爱好是什么呢？"],
            animation: nil,
            options: [],
            introTexts: ["最想聊的是"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
