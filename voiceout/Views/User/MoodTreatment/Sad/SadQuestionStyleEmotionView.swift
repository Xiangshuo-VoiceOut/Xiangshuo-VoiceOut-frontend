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
                        
//                        Button {
//                            isPlayingMusic.toggle()
//                        } label: {
//                            Image(isPlayingMusic ? "music" : "stop-music")
//                                .resizable()
//                                .frame(width: 48, height: 48)
//                        }
//                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                            }
                            .id(currentTextIndex)
                        }
                        .font(.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    emotionInputArea
                    
                    Spacer()
                }
                .padding(.horizontal, ViewSpacing.large)
                
                bottomButtonArea
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var emotionInputArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            Text("在这里写下你想说的话...")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textBrandPrimary)
                .multilineTextAlignment(.center)
                .frame(width: 252, alignment: .center)
            
            TextEditor(text: $userInput)
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .focused($isTextFieldFocused)
                .frame(minHeight: 120, maxHeight: 200)
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.base)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: StrokeWidth.width100.value)
                )
            
            HStack(spacing: ViewSpacing.medium) {
                Button {
                } label: {
                    HStack {
                        Image(systemName: "mic.fill")
                            .font(.typography(.bodyMedium))
                        Text("语音输入")
                            .font(.typography(.bodySmall))
                    }
                    .foregroundColor(.textBrandPrimary)
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical,ViewSpacing.small)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.small.value)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.small.value)
                            .stroke(Color.surfacePrimary, lineWidth: StrokeWidth.width100.value)
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
                .background(Color.surfaceBrandPrimary)
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
