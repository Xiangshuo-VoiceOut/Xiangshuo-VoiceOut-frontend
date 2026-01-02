//
//  SadQuestionStyleInteractiveDialogueView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/17/25.
//

import SwiftUI

struct CommonQuestionStyleInteractiveDialogueView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = true
    @State private var textDone = false
    @State private var introDone = false
    @State private var showCurrentText = true
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex].replacingOccurrences(of: "，", with: "，\n")
            .replacingOccurrences(of: ",", with: ",\n")
    }
    
    private var hasIntroText: Bool {
        return currentTextIndex == 0 && !(question.introTexts?.isEmpty ?? true)
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        var text = introTexts[0]
        text = text.replacingOccurrences(of: "，", with: "，\n")
        text = text.replacingOccurrences(of: ",", with: ",\n")
        text = text.replacingOccurrences(of: "？", with: "？\n")
        text = text.replacingOccurrences(of: "?", with: "?\n")
        return text
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
    }
    
    private var shouldShowContinueButton: Bool {
        if hasIntroText {
            return introDone
        } else {
            return textDone
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let safeAreaBottom = proxy.safeAreaInsets.bottom
            
            ZStack(alignment: .bottom) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                // 主内容区域（可滚动）
                ScrollView {
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            HStack {
                                Spacer()
                                Image("cloud-chat")
                                    .resizable()
                                    .frame(width: 168, height: 120)
                                    .padding(.vertical, ViewSpacing.medium)
                                    .padding(.horizontal, ViewSpacing.xxxsmall)
                                Spacer()
                            }
                            
//                            Button {
//                                isPlayingMusic.toggle()
//                            } label: {
//                                Image(isPlayingMusic ? "music" : "stop-music")
//                                    .resizable()
//                                    .frame(width: 48, height: 48)
//                            }
//                            .padding(.leading, ViewSpacing.medium)
                        }
                        .padding(.bottom, ViewSpacing.large)

                        if showCurrentText {
                            VStack(spacing: 0) {
                                VStack {
                                    TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                        textDone = true
                                    }
                                    .id(currentTextIndex)
                                    .font(.typography(.bodyMedium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textPrimary)
                                    .frame(width: 358, alignment: .top)
                                }
                                .frame(minHeight: 22.4 * 2, alignment: .top)
                                
                                if hasIntroText {
                                    Color.clear
                                        .frame(height: 16)
                                    
                                    VStack {
                                        if textDone {
                                            TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                                introDone = true
                                            }
                                            .id("intro-\(currentTextIndex)")
                                            .font(.typography(.bodyMedium))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.textBrandPrimary)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(width: 358, alignment: .top)
                                        }
                                    }
                                    .frame(width: 358)
                                    .frame(minHeight: 22.4 * 4, alignment: .top)
                                }
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                        }
                        
                        // 底部留白，避免内容被按钮遮挡
                        Color.clear
                            .frame(height: 120)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // 底部固定按钮区域
                if shouldShowContinueButton,
                   let confirmOption = question.options.first(where: { $0.exclusive == true }) ?? (question.options.count == 1 ? question.options.first : nil) {
                    Button(confirmOption.text) {
                        onSelect(confirmOption)
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(width: 114, height: 44)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.full.value)
                    .foregroundColor(.textBrandPrimary)
                    .font(Font.typography(.bodyMedium))
                    .kerning(0.64)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, safeAreaBottom > 0 ? safeAreaBottom + ViewSpacing.small : ViewSpacing.xlarge + ViewSpacing.large + ViewSpacing.xsmall)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .onChange(of: currentTextIndex) { _, _ in
            textDone = false
            introDone = false
        }
    }
}

#Preview {
    CommonQuestionStyleInteractiveDialogueView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 10,
            uiStyle: .styleInteractiveDialogue,
            texts: [
                "旧的故事已经温柔谢幕，新的生机正在你的勇气中悄悄发芽。别担心未来的路还有雾气，因为你本身就是自带光芒的小星辰呀！小云朵会化作最柔软的微风，在你每一个出发的时刻，为你加油打气！"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "继续", next: 4, exclusive: true)
            ],
            introTexts: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onSelect: { _ in }
    )
    .environmentObject(RouterModel())
}
