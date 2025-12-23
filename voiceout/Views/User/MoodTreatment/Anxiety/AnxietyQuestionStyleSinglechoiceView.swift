//
//  AnxietyQuestionStyleSinglechoiceView.swift
//  voiceout
//
//  Created by Ziyang Ye on 11/10/25.
//

import SwiftUI

struct AnxietyQuestionStyleSinglechoiceView: View {
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
//                musicButton
                anxietybookBackground
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
    
//    private var musicButton: some View {
//        Button { isPlayingMusic.toggle() } label: {
//            Image(isPlayingMusic ? "music" : "stop-music")
//                .resizable()
//                .frame(width: 48, height: 48)
//        }
//        .padding(.leading, ViewSpacing.medium)
//    }
    
    private var anxietybookBackground: some View {
        VStack {
            Spacer()
            Image("anxietybook")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func mainContent(texts: [String]) -> some View {
        VStack(spacing: 0) {
            chatBubbleSection(texts: texts)
            
            if showOptions {
                optionsSection
            }
            
            Spacer()
        }
        .padding(.top, ViewSpacing.base+ViewSpacing.xlarge)
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

            VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                AnxietyBubbleScrollView(
                    texts: texts,
                    displayedCount: $displayedCount,
                    bubbleHeight: $bubbleHeight,
                    bubbleSpacing: ViewSpacing.small,
                    totalHeight: bubbleFrameHeight
                )
            }
            .padding(0)
            .frame(width: 268, alignment: .bottomLeading)
            .frame(height: bubbleFrameHeight)
            .imageShadow()
            .offset(y: -35.5)

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
            .padding(.top, ViewSpacing.medium+ViewSpacing.large)
            .padding(.trailing, ViewSpacing.medium)
            .transition(.opacity)
        }
    }
    
    private func optionButton(option: MoodTreatmentAnswerOption) -> some View {
        HStack {
            Spacer()
            Button { 
                selectedOptionId = option.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    onSelect(option)
                }
            } label: {
                optionButtonLabel(option: option, isSelected: selectedOptionId == option.id)
            }
        }
    }
    
    private func optionButtonLabel(option: MoodTreatmentAnswerOption, isSelected: Bool) -> some View {
        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
            Text(option.text)
                .font(Font.typography(.bodyMedium))
                .multilineTextAlignment(.trailing)
                .foregroundColor(.grey500)

        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.base)
        .background(
            isSelected ? Color(red: 0.992, green: 0.937, blue: 0.894) : Color(red: 0.98, green: 0.99, blue: 1)
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 1.5)
                .stroke(Color(red: 0.757, green: 0.533, blue: 0.369),lineWidth: 3)
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

private struct AnxietyChatBubbleView: View {
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
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .frame(width: 244, alignment: .topLeading)
                .padding(.horizontal, ViewSpacing.base)
                .padding(.vertical, ViewSpacing.medium)

            if showTriangle {
                Image("vector49")
                    .resizable()
                    .frame(width: 15, height: 14)
                    .offset(x: ViewSpacing.large, y: ViewSpacing.xxsmall+ViewSpacing.base)
            }
        }
    }
}

private struct AnxietyBubbleScrollView: View {
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
                            let isLast = idx == displayedCount - 1
                            AnxietyChatBubbleView(text: line, showTriangle: isLast)
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
    AnxietyQuestionStyleSinglechoiceView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 10,
            uiStyle: .styleAnxietySinglechoice,
            texts: [
                "小云朵发现你似乎很紧张不安，",
                "能告诉我现在你是什么感受吗？"
            ],
            animation: nil,
            options: [
                .init(key: "1", text: "有点紧张，好像有点焦虑【轻度焦虑】", next: 2, exclusive: false),
                .init(key: "2", text: "感觉不安，已经影响到生活了【中度焦虑】", next: 3, exclusive: false),
                .init(key: "3", text: "控制不住的焦虑，感觉很糟糕。【重度焦虑】", next: 4, exclusive: false)
            ],
            introTexts: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        ),
        onSelect: { _ in }
    )
}
