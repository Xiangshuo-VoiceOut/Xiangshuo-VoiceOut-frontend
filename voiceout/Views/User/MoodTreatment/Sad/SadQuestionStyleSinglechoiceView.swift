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
    @State private var selectedOptionId: UUID? = nil

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
            Image("newmill")
                .resizable()
                .scaledToFit() // 保持完整图片显示
                .frame(maxWidth: .infinity) // 宽度填满，高度自适应
        }
    }
    
    @ViewBuilder
    private func mainContent(texts: [String]) -> some View {
        VStack(spacing: 0) {
            chatBubbleSection(texts: texts)
            
            if showOptions {
                optionsSection
            }
            
            Spacer() // 让图片自适应高度
        }
        .padding(.top, 44) // 避免对话框遮挡header（header高度44px）
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

            VStack(alignment: .leading, spacing: 10) {
                SadBubbleScrollView(
                    texts: texts,
                    displayedCount: $displayedCount,
                    bubbleHeight: $bubbleHeight,
                    bubbleSpacing: 8,
                    totalHeight: bubbleFrameHeight
                )
            }
            .padding(0)
            .frame(width: 268, alignment: .bottomLeading)
            .frame(height: bubbleFrameHeight)
            .shadow(color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03), radius: 8.95, x: 5, y: 3)
            .shadow(color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08), radius: 5.75, x: 2, y: 4)
            .offset(y: -35.5) // 向上偏移云朵高度的一半，使题目在云朵中间位置，模拟云朵说话的感觉

            Spacer()
        }
    }
    
    @ViewBuilder
    private var optionsSection: some View {
        if showOptions {
            VStack(spacing: ViewSpacing.small) {
                ForEach(question.options) { option in
                    optionButton(option: option)
                }
            }
            .padding(.top, 40) // 第一个选项的起始位置距离对话云朵y轴上40px
            .padding(.trailing, ViewSpacing.medium)
            .transition(.opacity)
        }
    }
    
    private func optionButton(option: MoodTreatmentAnswerOption) -> some View {
        HStack {
            Spacer()
            Button { 
                // 显示选中效果
                selectedOptionId = option.id
                
                // 150ms 后跳转
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    onSelect(option)
                }
            } label: {
                optionButtonLabel(option: option, isSelected: selectedOptionId == option.id)
            }
        }
    }
    
    private func optionButtonLabel(option: MoodTreatmentAnswerOption, isSelected: Bool) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(option.text)
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 46, alignment: .trailing)
        .background(
            isSelected ? LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.88, green: 0.96, blue: 1), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.71, green: 0.88, blue: 0.93), location: 0.81),
                    Gradient.Stop(color: Color(red: 0.71, green: 0.88, blue: 0.93), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0, y: 0.5),
                endPoint: UnitPoint(x: 1, y: 0.5)
            ) : LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.98, green: 0.99, blue: 1)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 1.5)
                        .stroke(Color(red: 0.56, green: 0.79, blue: 0.9), lineWidth: 3)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 1.5)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.556, green: 0.792, blue: 0.902), // #8ECAE6
                                    Color(red: 0.129, green: 0.620, blue: 0.737)  // #219EBC
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                }
            }
        )
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

// 自定义对话框组件，只有最后一个显示小三角
private struct SadChatBubbleView: View {
    let text: String
    let showTriangle: Bool
    static let width: CGFloat = 268

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 2, y: 2)
                .frame(width: Self.width)

            Text(text)
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
                .frame(width: 244, alignment: .topLeading)
                .padding(.horizontal, ViewSpacing.base)
                .padding(.vertical, ViewSpacing.medium)

            if showTriangle {
                Image("vector49")
                    .resizable()
                    .frame(width: 15, height: 14)
                    .offset(x: ViewSpacing.large, y: 14)
            }
        }
    }
}

// 自定义BubbleScrollView，只有最后一个对话框显示小三角
private struct SadBubbleScrollView: View {
    let texts: [String]
    @Binding var displayedCount: Int
    @Binding var bubbleHeight: CGFloat
    let bubbleSpacing: CGFloat
    let totalHeight: CGFloat

    private let animationDuration: TimeInterval = 0.25

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: bubbleSpacing) {
                    ForEach(Array(texts.prefix(displayedCount).enumerated()), id: \.offset) { idx, line in
                        HStack {
                            // 只有最后一个对话框显示小三角
                            let isLast = idx == displayedCount - 1
                            SadChatBubbleView(text: line, showTriangle: isLast)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: BubbleHeightKey.self, value: geo.size.height)
                            }
                        )
                        .id(idx)
                    }
                }
                .frame(height: totalHeight, alignment: .bottom)
                .onPreferenceChange(BubbleHeightKey.self) { bubbleHeight = $0 }
            }
            .frame(height: totalHeight + 14)
            .onAppear {
                scrollToLast(with: reader)
            }
            .onChange(of: displayedCount) { _, _ in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    scrollToLast(with: reader)
                }
            }
        }
    }

    private func scrollToLast(with reader: ScrollViewProxy) {
        let lastIndex = max(0, displayedCount - 1)
        reader.scrollTo(lastIndex, anchor: .bottom)
    }

    private struct BubbleHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
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
