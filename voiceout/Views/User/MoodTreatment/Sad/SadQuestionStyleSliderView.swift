//
//  SadQuestionStyleSliderView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/18/25.
//

import SwiftUI

struct SadQuestionStyleSliderView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var sliderValue = 2.0 // 默认3分（0-4对应1-5分，2对应3分）
    @State private var currentStep: Int = 3 // 当前选中的分数（1-5）
    @State private var isPlayingMusic = true
    @State private var completedLines = 0
    
    private let typingInterval: TimeInterval = 0.08
    
    private var displayTexts: [String] {
        if let texts = question.texts, !texts.isEmpty {
            // 将逗号替换为逗号+换行符
            return texts.map { text in
                text.replacingOccurrences(of: "，", with: "，\n")
                    .replacingOccurrences(of: ",", with: ",\n")
            }
        }
        return ["你觉得外部环境或者他人认可的因素，对于这件事的重要程度是多少呢？"]
    }
    
    private var totalTypeCount: Int {
        displayTexts.count
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                    
                    Button { isPlayingMusic.toggle() } label: {
                        Image(isPlayingMusic ? "music" : "stop-music")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    .padding(.leading, ViewSpacing.medium)
                }
                .padding(.bottom, 24) // 云朵和text之间：24px
                
                // text区域
                VStack(spacing: 0) {
                    ForEach(Array(displayTexts.enumerated()), id: \.offset) { idx, line in
                        Text(line)
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                            .frame(width: 358, alignment: .top)
                            .padding(.bottom, idx < displayTexts.count - 1 ? ViewSpacing.medium : 0) // 最后一行不加bottom padding
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)
                .onAppear {
                    // text直接显示，立即设置completedLines
                    completedLines = totalTypeCount
                }
                
                // text和slide距离140px（从text的最后一行到slide）
                Color.clear
                    .frame(height: 140)
                
                // text直接显示后，立即显示slider
                VStack(spacing: 0) {
                    // Slider容器
                    HStack(alignment: .center, spacing: -2) {
                        // Slider
                        SliderView(value: $sliderValue,
                                   minValue: 0, maxValue: 4,
                                   trackColor: Color(red: 0.4, green: 0.72, blue: 0.6), // colorBrandBrandPrimary - 左边绿色
                                   thumbInnerColor: Color(red: 0.4, green: 0.72, blue: 0.6), // colorBrandBrandPrimary
                                   thumbOuterColor: Color(red: 0.96, green: 0.96, blue: 0.96), // colorGrey75
                                   thumbInnerDiameter: 24,
                                   thumbOuterDiameter: 24)
                        .frame(width: 342, height: 8)
                        .onChange(of: sliderValue) { oldValue, newValue in
                            // 更新当前分数（0-4对应1-5分）
                            currentStep = Int(newValue) + 1
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // 12345距离slide 20px
                    Color.clear
                        .frame(height: 20)
                    
                    // 1-5数字提示 - 在slider下方
                    HStack(alignment: .center, spacing: -2) {
                        HStack(spacing: 0) {
                            ForEach(1...5, id: \.self) { number in
                                Text("\(number)")
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.82)) // textTextLight
                                if number < 5 {
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 342)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // slide和继续按钮之间：269px
                Color.clear
                    .frame(height: 269)
                
                // 继续按钮 - 使用填空题风格
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
                .padding(.bottom, 55) // 距离屏幕最下方55px
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    SadQuestionStyleSliderView(
        question: MoodTreatmentQuestion(
            id: 4,
            totalQuestions: 10,
            type: .slider,
            uiStyle: .styleSlider,
            texts: ["你觉得外部环境或者他人认可的因素，对于这件事的重要程度是多少呢？"],
            animation: nil,
            options: [],
            introTexts: [],
            showSlider: true,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
}
