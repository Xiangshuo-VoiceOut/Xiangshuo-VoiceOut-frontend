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
    @State private var isPlayingMusic = true
    @State private var textDone = false // text播放完成
    @State private var introDone = false // introtext播放完成
    @State private var showCurrentText = true
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        // 将逗号替换为逗号+换行符
        return texts[currentTextIndex].replacingOccurrences(of: "，", with: "，\n")
            .replacingOccurrences(of: ",", with: ",\n")
    }
    
    private var hasIntroText: Bool {
        // 第一句话（索引0）显示introtext
        return currentTextIndex == 0 && !(question.introTexts?.isEmpty ?? true)
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        // 第一句话显示第一个introtext
        var text = introTexts[0]
        // 将逗号和问号替换为换行符
        text = text.replacingOccurrences(of: "，", with: "，\n")
        text = text.replacingOccurrences(of: ",", with: ",\n")
        text = text.replacingOccurrences(of: "？", with: "？\n")
        text = text.replacingOccurrences(of: "?", with: "?\n")
        return text
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
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
                                .padding(.vertical, 15.569)
                                .padding(.horizontal, 0.842)
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
                    .padding(.bottom, 24) // 云朵和text之间：24px

                    // text区域 - 使用固定布局，确保各区域相对独立
                    if showCurrentText {
                        VStack(spacing: 0) {
                            // text区域 - 预留足够空间（假设最多2行），防止挤压下方内容
                            VStack {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                    // text播放完成后
                                    textDone = true
                                }
                                .id(currentTextIndex) // 添加key强制重新渲染
                                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                                .frame(width: 358, alignment: .top)
                            }
                            .frame(minHeight: 22.4 * 2, alignment: .top) // 预留2行的高度（22.4px * 2 = 44.8px）
                            
                            // text的最后一行和introtext之间：16px - 使用固定间距
                            if hasIntroText {
                                Color.clear
                                    .frame(height: 16) // 固定间距16px
                                
                                // introtext区域 - 使用固定高度容器，防止挤压上方内容
                                VStack {
                                    // text播放完后才播放introtext
                                    if textDone {
                                        TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                            // introtext播放完成后，显示输入框和按钮
                                            introDone = true
                                        }
                                        .id("intro-\(currentTextIndex)") // 添加key强制重新渲染
                                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.4, green: 0.72, blue: 0.6)) // textTextBrand
                                        .fixedSize(horizontal: false, vertical: true) // 允许文本换行，防止截断
                                        .frame(width: 358, alignment: .top)
                                    }
                                }
                                .frame(width: 358)
                                .frame(minHeight: 22.4 * 4, alignment: .top) // 使用minHeight允许扩展，防止截断
                            }
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                    }
                    
                    Spacer()
                }
                
                // 继续按钮固定在底部
                if introDone {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button("继续") {
                                // 点击继续直接进入下一题
                                onContinue()
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.small)
                            .frame(width: 114, height: 44)
                            .background(Color.surfacePrimary) // 白底
                            .cornerRadius(CornerRadius.full.value)
                            .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0)) // 绿色 #67B899
                            .font(Font.typography(.bodyMedium))
                            .kerning(0.64)
                            .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .padding(.bottom, 53) // 距离屏幕最下方53px
                    }
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .onChange(of: currentTextIndex) { _, _ in
            // 切换文本时重置状态
            textDone = false
            introDone = false
        }
    }
}

#Preview {
    SadQuestionStyleInteractiveDialogueView(
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
