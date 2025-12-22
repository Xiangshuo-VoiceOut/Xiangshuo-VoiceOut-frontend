//
//  AnxietyQuestionStyleMatchingView.swift
//  voiceout
//
//  Created by Ziyang Ye on 10/15/25.
//

import SwiftUI

struct AnxietyQuestionStyleMatchingView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var selectedOptions: Set<String> = []
    @State private var showOptions = false
    
    private let typingInterval: TimeInterval = 0.1
    
    // 硬编码的测试选项
    private let testOptions = [
        "善良", "诚实", "责任感", "勇气", "感恩", "礼貌",
        "耐心", "坚持", "独立", "宽容", "同情心", "正义感"
    ]
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
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
                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.medium) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                    // 打字完成后可以执行的操作
                                    if currentTextIndex == 0 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showOptions = true
                                        }
                                    }
                                }
                                .id(currentTextIndex)
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, ViewSpacing.small)
                        }
                        
                        // 选项区域
                        if showOptions && currentTextIndex == 0 {
                            optionsArea
                        }
                        
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
    
    private var optionsArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            // 选项网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ViewSpacing.small), count: 3), spacing: ViewSpacing.medium) {
                ForEach(testOptions, id: \.self) { option in
                    AnxietyOptionCircleView(
                        option: option,
                        isSelected: selectedOptions.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
            .padding(.horizontal, ViewSpacing.medium)
        }
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if showCurrentText {
                Button("继续") {
                    handleContinue()
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(.textBrandPrimary)
                .frame(width: 114, height: 44)
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.grey50)
                .cornerRadius(CornerRadius.full.value)
                .padding(.bottom, ViewSpacing.large)
            }
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
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

// 选项圆形视图
struct AnxietyOptionCircleView: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    // #A9D8F1 color
    private let optionColor = Color(red: 169/255.0, green: 216/255.0, blue: 241/255.0)
    
    var body: some View {
        Button(action: onTap) {
            Text(option)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.vertical, 23.4)
                .padding(.horizontal, 7.2)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(isSelected ? optionColor : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(optionColor, lineWidth: 2)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AnxietyQuestionStyleMatchingView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 10,
            uiStyle: .styleAnxietyMatching,
            texts: [
                "然后，小云朵希望你能圈出自己具有的品德：",
                "哇！\n小云朵发现你真的有很多值得骄傲的地方呢！\n不要低估自己的闪光点，\n你已经拥有这么多优秀的品质啦。\n继续相信自己，\n这些品质会让你的生活更加精彩，\n也会带给身边的人温暖哦！",
                "小云朵想告诉你，\n其实你比你想象的更加优秀哦！\n有时候我们会忽略自己的优点，\n但它们真的在那里。\n再仔细看看，\n你还有哪些品质值得被肯定呢？\n给自己多一点鼓励，\n小云朵相信你有更多的闪光点等着被发现！"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        ),
        onContinue: {}
    )
}

