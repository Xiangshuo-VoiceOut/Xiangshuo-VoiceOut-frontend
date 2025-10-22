//
//  SadQuestionStyleInteractiveDialogueView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/17/25.
//

import SwiftUI

struct SadQuestionStyleInteractiveDialogueView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var userInput = ""
    @State private var showInputField = false
    @State private var showContinueButton = true
    @State private var isPlayingMusic = true
    @State private var introDone = false
    @State private var inputDone = false
    @State private var showCurrentText = true
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
    }
    
    private var hasIntroText: Bool {
        // 第三句话（索引2）和第五句话（索引4）显示introtext
        return currentTextIndex == 2 || currentTextIndex == 4
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        
        if currentTextIndex == 2 {
            // 第三句话显示第一个introtext
            return introTexts[0]
        } else if currentTextIndex == 4 {
            // 第五句话显示第二个introtext
            return introTexts.count > 1 ? introTexts[1] : introTexts[0]
        }
        
        return ""
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
                        
                        if showCurrentText && hasIntroText && !inputDone {
                            TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                // introtext打字完成后可以执行的操作
                            }
                            .id("intro-\(currentTextIndex)") // 添加key强制重新渲染
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6)) // #67B899
                            .multilineTextAlignment(.center)
                            .frame(width: 252, alignment: .center)
                            
                            HStack(alignment: .top, spacing: ViewSpacing.small) {
                                Image("edit")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.textLight)
                                
                                TextField("...", text: $userInput)
                                    .font(.typography(.bodyMedium))
                                    .foregroundColor(.textLight)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.base)
                            .frame(maxWidth: .infinity, minHeight: 57, alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            
                            Button("完成") {
                                inputDone = true
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.small)
                            .frame(width: 114, height: 44)
                            .background(Color.surfacePrimary)
                            .disabled(userInput.isEmpty)
                            .cornerRadius(CornerRadius.full.value)
                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                            .font(Font.typography(.bodyMedium))
                            .kerning(0.64)
                            .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.bottom,ViewSpacing.xsmall+ViewSpacing.large)
                    
                    Spacer()
                    
                    if showCurrentText && !hasIntroText {
                        Button(isLastText ? "完成" : "继续") {
                            handleContinue()
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                    }
                    
                    if showCurrentText && hasIntroText && inputDone {
                        Button(isLastText ? "完成" : "继续") {
                            handleContinue()
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
    
    private func handleContinue() {
        if currentTextIndex < (question.texts?.count ?? 0) - 1 {
            // 还有下一句文本
            currentTextIndex += 1
            showCurrentText = true  // 保持显示状态
            inputDone = false
            userInput = ""
        } else {
            // 所有文本都显示完了，进入下一题
            onContinue()
        }
    }
}

#Preview {
    SadQuestionStyleInteractiveDialogueView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 10,
            type: .fillInBlank,
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
            introTexts: [
                "在这里写下一个你想让别人记住你的一件事吧！",
                "用简短几句话包含自己的名字，年纪，来自哪里，兴趣爱好，以及自己的一个fun fact书写下来可以更加有利于整理逻辑和记忆哦：）"
            ],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {
            // 预览用的空闭包
        }
    )
    .environmentObject(RouterModel())
}
