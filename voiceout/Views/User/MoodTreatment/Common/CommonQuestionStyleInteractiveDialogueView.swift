//
//  SadQuestionStyleInteractiveDialogueView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/17/25.
//

import SwiftUI

struct CommonQuestionStyleInteractiveDialogueView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
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
            let screenHeight = proxy.size.height
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
                                .padding(.vertical, ViewSpacing.medium)
                                .padding(.horizontal, ViewSpacing.xxxsmall)
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
                    
                    Spacer()
                }
                
                if shouldShowContinueButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button("继续") {
                                onContinue()
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
                            Spacer()
                        }
                        .padding(.bottom,ViewSpacing.xlarge+ViewSpacing.medium+ViewSpacing.xsmall+ViewSpacing.xxxsmall )
                    }
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
                "和小云朵一起从自我介绍开始，迈出拓展社交圈的第一步吧！",
                "让小云朵帮助xxx一起准备一个关于自己fun fact吧！",
                "准备一个fun fact在自我介绍时，能够快速拉近与他人的距离，让气氛变得轻松愉快☆´∀｀☆ ~ 这不仅能展现你的个性，还能帮助别人更容易记住你，从而开启更自然的对话。",
                "这可以是自己的特点，最喜欢的兴趣爱好，坚持最久的习惯，小怪癖",
                "接下来来练习一下自我介绍吧！",
                "注意，在社交过程中，眼神对视和微笑是拉进人与人距离的重要元素。尝试对着镜子多练习一下这两个技能！"
            ],
            animation: nil,
            options: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {
        }
    )
    .environmentObject(RouterModel())
}
