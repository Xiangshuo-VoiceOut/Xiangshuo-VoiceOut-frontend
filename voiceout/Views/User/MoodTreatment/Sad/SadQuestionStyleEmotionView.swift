//
//  SadQuestionStyleEmotionView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/23/25.
//

import SwiftUI

struct SadQuestionStyleEmotionView: View {
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
                        
                        // 输入区域 - 始终显示
                        emotionInputArea
                        
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.large)
                    
                    // 底部按钮区域
                    bottomButtonArea
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var emotionInputArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            // 输入提示
            Text("在这里写下你想说的话...")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6)) // #67B899
                .multilineTextAlignment(.center)
                .frame(width: 252, alignment: .center)
            
            // 文本输入区域
            TextEditor(text: $userInput)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.textPrimary)
                .focused($isTextFieldFocused)
                .frame(minHeight: 120, maxHeight: 200)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // 语音输入按钮
            HStack(spacing: ViewSpacing.medium) {
                Button {
                    // TODO: 实现语音输入功能
                } label: {
                    HStack {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 16))
                        Text("语音输入")
                            .font(.system(size: 14, weight: .regular))
                    }
                    .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.surfacePrimary)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 1)
                    )
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if !userInput.isEmpty {
                Button("完成") {
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

#Preview {
    SadQuestionStyleEmotionView(
        question: MoodTreatmentQuestion(
            id: 9,
            totalQuestions: 10,
            type: .custom,
            uiStyle: .styleEmotion,
            texts: ["当你准备好了，\n可以在心里对ta说出那些一直埋藏在心底的话，\n也许是遗憾、困惑，或是未曾表达的思念和祝福。不用急，慢慢地，\n一点一点地释放出来。"],
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
