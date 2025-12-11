//
//  SadQuestionStyleMatchingView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/25/25.
//

import SwiftUI

struct SadQuestionStyleMatchingView: View {
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
        "责任感", "诚实", "善良", "独立", "宽容", "同情心", "正义感", "感恩", "礼貌"
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
                    // 云朵参数
                    ZStack(alignment: .topLeading) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120, alignment: .center)
                                .padding(.horizontal, 0.84157)
                                .padding(.vertical, 15.56904)
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

                    VStack(spacing: ViewSpacing.medium) {
                        if showCurrentText {
                            // text参数
                            Text(currentText)
                                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                                .frame(width: 358, alignment: .top)
                                .padding(.bottom, ViewSpacing.small)
                                .onAppear {
                                    // 文本直接显示后，如果是第一段文本，延迟显示选项
                                    if currentTextIndex == 0 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showOptions = true
                                        }
                                    }
                                }
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
                    OptionCircleView(
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
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .frame(width: 114, height: 44)
                .background(Color.surfacePrimary) // 白底
                .cornerRadius(CornerRadius.full.value)
                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0)) // 绿色 #67B899
                .font(Font.typography(.bodyMedium))
                .kerning(0.64)
                .multilineTextAlignment(.center)
                .padding(.bottom, 55) // 距离屏幕最下方55px
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
struct OptionCircleView: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 背景圆形
                VStack(alignment: .center, spacing: 18) {
                    Text(option)
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                }
                .padding(.horizontal, 7.2)
                .padding(.vertical, 23.4)
                .frame(width: 96, height: 96, alignment: .center)
                .background(isSelected ? Color(red: 0xAF/255.0, green: 0xE2/255.0, blue: 0xFD/255.0) : Color(red: 0.99, green: 1, blue: 1))
                .cornerRadius(999)
            }
            .overlay(
                // 使用overlay添加贴图，避免被cornerRadius裁剪
                ZStack {
                    // 右下角的curve贴图（未选中时显示curve，选中时显示curve3）
                    if !isSelected {
                        Image("curve")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .offset(x: 20, y: 20) // 右下角位置
                    } else {
                        Image("curve3")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(red: 0xC0/255.0, green: 0xE9/255.0, blue: 0xFF/255.0)) // #C0E9FF
                            .frame(width: 48, height: 48)
                            .offset(x: 20, y: 20) // 右下角位置
                    }
                    
                    // 上方的curve2贴图（选中时显示，12点位置偏左下）
                    if isSelected {
                        Image("curve2")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(red: 0xC0/255.0, green: 0xE9/255.0, blue: 0xFF/255.0)) // #C0E9FF
                            .frame(width: 24, height: 24) // 缩小一倍
                            .offset(x: -10, y: -36) // 12点位置往左下
                    }
                },
                alignment: .center
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SadQuestionStyleMatchingView(
        question: MoodTreatmentQuestion(
            id: 11,
            totalQuestions: 10,
            uiStyle: .styleMatching,
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
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
