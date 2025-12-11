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
    @State private var textDone = false // text播放完成
    @State private var introDone = false // introtext播放完成
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        // 将逗号替换为逗号+换行符
        return texts[currentTextIndex].replacingOccurrences(of: "，", with: "，\n")
            .replacingOccurrences(of: ",", with: ",\n")
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        // 将逗号和问号替换为换行符
        var text = introTexts[0]
        text = text.replacingOccurrences(of: "，", with: "，\n")
        text = text.replacingOccurrences(of: ",", with: ",\n")
        text = text.replacingOccurrences(of: "？", with: "？\n")
        text = text.replacingOccurrences(of: "?", with: "?\n")
        return text
    }
    
    private var hasIntroText: Bool {
        // 第一句话（索引0）显示introtext
        return currentTextIndex == 0 && !(question.introTexts?.isEmpty ?? true)
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
                                Text(currentText)
                                    .id(currentTextIndex) // 添加key强制重新渲染
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                                    .frame(width: 358, alignment: .top)
                                    .onAppear {
                                        // text直接显示，不需要逐字播放
                                        textDone = true
                                    }
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
                                
                                // introtext和输入区域之间：40px - 使用固定间距
                                // introtext播放完后才显示输入框和按钮
                                if introDone {
                                    Color.clear
                                        .frame(height: 40) // 固定间距40px
                                    
                                    // 填空区域
                                    fillInBlankArea
                                    
                                    // 填写框和"我写好了"按钮之间：142px
                                    Color.clear
                                        .frame(height: 142) // 填写框和"我写好了"按钮距离142px
                                    
                                    // 继续按钮距离屏幕最下方68px
                                    Button("我写好了") {
                                        // 点击继续直接进入下一题
                                        onContinue()
                                    }
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.vertical, ViewSpacing.small)
                                    .frame(width: 114, height: 44)
                                    .background(Color.surfacePrimary) // 白底
                                    .disabled(userInput.isEmpty)
                                    .cornerRadius(CornerRadius.full.value)
                                    .foregroundColor(userInput.isEmpty ? Color.gray : Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0)) // 输入完成后绿色，否则灰色
                                    .font(Font.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 68) // 距离屏幕最下方68px
                                }
                            } else {
                                // 如果没有introtext，text播放完后直接显示填空区域
                                if textDone {
                                    Color.clear
                                        .frame(height: 40) // text和填写框距离40px
                                    
                                    // 填空区域
                                    fillInBlankArea
                                    
                                    // 填写框和"我写好了"按钮之间：142px
                                    Color.clear
                                        .frame(height: 142) // 填写框和"我写好了"按钮距离142px
                                    
                                    // 继续按钮距离屏幕最下方68px
                                    Button("我写好了") {
                                        // 点击继续直接进入下一题
                                        onContinue()
                                    }
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.vertical, ViewSpacing.small)
                                    .frame(width: 114, height: 44)
                                    .background(Color.surfacePrimary) // 白底
                                    .disabled(userInput.isEmpty)
                                    .cornerRadius(CornerRadius.full.value)
                                    .foregroundColor(userInput.isEmpty ? Color.gray : Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0)) // 输入完成后绿色，否则灰色
                                    .font(Font.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 68) // 距离屏幕最下方68px
                                }
                            }
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                    }
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .onChange(of: currentTextIndex) { _, _ in
            // 切换文本时重置状态
            textDone = false
            introDone = false
            userInput = ""
        }
    }
    
    
    private var fillInBlankArea: some View {
        ZStack(alignment: .topLeading) {
            // 输入框 - 使用TextEditor支持多行输入
            TextEditor(text: $userInput)
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                .tint(.black) // 光标颜色为黑色
                .focused($isTextFieldFocused)
                .scrollContentBackground(.hidden) // 隐藏TextEditor的默认背景
                .frame(width: 294, height: 241, alignment: .topLeading) // 填满整个框的高度
                .padding(.top, 25)
                .padding(.leading, 16)
                .padding(.trailing, 11)
                .overlay(
                    // 占位符 - 与输入位置对齐（TextEditor有默认内边距，需要调整）
                    Group {
                        if userInput.isEmpty {
                            Text(" 请填写") // 前面加一个空格
                                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18)) // 与用户输入字体大小一致
                                .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.82)) // textTextLight
                                .allowsHitTesting(false) // 不拦截点击事件
                                .padding(.top, 25 + 8) // TextEditor默认有8px的顶部内边距
                                .padding(.leading, 16 + 5) // TextEditor默认有5px的左侧内边距
                        }
                    },
                    alignment: .topLeading
                )
        }
        .frame(width: 294 + 16 + 11, height: 241, alignment: .topLeading) // 固定宽度和高度
        .background(Color(red: 0.98, green: 0.99, blue: 1)) // surfaceSurfacePrimary
        .cornerRadius(16) // radiusRadiusRounded2
        .clipped() // 确保内容不会超出边界
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
