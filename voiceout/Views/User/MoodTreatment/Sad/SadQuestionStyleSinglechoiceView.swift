//
//  SadQuestionStyleSinglechoiceView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/15/25.
//

import SwiftUI

struct SadQuestionStyleSinglechoiceView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false
    @State private var selectedOption: UUID? = nil

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
        }
    }
    
    private var backgroundView: some View {
        Color.surfaceBrandTertiaryGreen
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
                .scaledToFit() // 保持完整图片显示
                .frame(maxWidth: .infinity) // 宽度填满，高度自适应
        }
    }
    
    @ViewBuilder
    private func mainContent(texts: [String]) -> some View {
        VStack(spacing: ViewSpacing.large) {
            chatBubbleSection(texts: texts)
            optionsSection
            Spacer() // 让图片自适应高度
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
                texts: texts,
                displayedCount: $displayedCount,
                bubbleHeight: $bubbleHeight,
                bubbleSpacing: 24,
                totalHeight: bubbleFrameHeight
            )
            .frame(height: bubbleFrameHeight)

            Spacer()
        }
    }
    
    @ViewBuilder
    private var optionsSection: some View {
        if showOptions {
            VStack(spacing: ViewSpacing.large) {
                VStack(spacing: ViewSpacing.small) {
                    ForEach(question.options) { option in
                        optionButton(option: option)
                    }
                }
                .padding(.top, ViewSpacing.medium+ViewSpacing.large)
                .padding(.trailing, ViewSpacing.medium)
                .transition(.opacity)
                
                // "我选好了"按钮
                if selectedOption != nil {
                    confirmButton
                        .transition(.opacity)
                }
            }
        }
    }
    
    private func optionButton(option: MoodTreatmentAnswerOption) -> some View {
        HStack {
            Spacer()
            Button { 
                selectedOption = option.id
                // 移除直接调用onSelect，改为只设置选中状态
            } label: {
                optionButtonLabel(option: option)
            }
        }
    }
    
    private func optionButtonLabel(option: MoodTreatmentAnswerOption) -> some View {
        HStack(spacing: ViewSpacing.small) {
            // 风logo - 只在选中时显示
            if selectedOption == option.id {
                Image("windlogo") // 使用你添加的windlogo图片
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            Text(option.text)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.grey500)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.base)
        .background(
            selectedOption == option.id 
                ? Color(red: 0.85, green: 0.95, blue: 1.0) // 浅蓝色背景
                : Color.surfacePrimary
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 2)
                .stroke(
                    Color(red: 0.42, green: 0.81, blue: 0.95), // 边框颜色保持一致
                    lineWidth: 4 // 边框粗细保持一致
                )
        )
    }
    
    private var confirmButton: some View {
        HStack {
            Spacer()
            Button {
                // 找到选中的选项并提交
                if let selectedId = selectedOption,
                   let selectedOption = question.options.first(where: { $0.id == selectedId }) {
                    onSelect(selectedOption)
                }
            } label: {
                Text("我选好了")
                    .font(Font.typography(.bodyMedium)) // 与选项字体大小一致
                    .foregroundColor(Color(red: 0.42, green: 0.81, blue: 0.95)) // 浅蓝色
            }
        }
        .padding(.trailing, ViewSpacing.medium)
        .padding(.top, ViewSpacing.xsmall) // 减少间距，紧贴选项
    }

    private func startBubbleSequence() {
        guard let texts = question.texts else { return }
        for idx in texts.indices {
            let delay = Double(idx) * (displayDuration + animationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    displayedCount += 1
                }
                if idx == texts.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeIn) {
                            showOptions = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SadQuestionStyleSinglechoiceView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 10,
            type: .singleChoice,
            uiStyle: .styleSinglechoice,
            texts: [
                "小云朵闻到了下雨的预兆，",
                "可以跟小云朵说说，",
                "你的失落程度现在是哪一种吗？"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "我有一点轻微的难过（轻度）", next: 2, exclusive: false),
                .init(key: "B", text: "我很伤心，这已经影响到了正常生活（中度）", next: 3, exclusive: false),
                .init(key: "C", text: "我完全沉浸于负面情绪里（重度）", next: 4, exclusive: false)
            ],
            introTexts: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onSelect: { _ in }
    )
}
