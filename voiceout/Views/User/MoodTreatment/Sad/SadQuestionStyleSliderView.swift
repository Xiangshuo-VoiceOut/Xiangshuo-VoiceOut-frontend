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
    
    @State private var sliderValue = 2.0
    @State private var currentStep: Int = 3
    @State private var isPlayingMusic = true
    @State private var completedLines = 0
    
    private let typingInterval: TimeInterval = 0.08
    
    private var displayTexts: [String] {
        if let texts = question.texts, !texts.isEmpty {
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
                .padding(.bottom, 24)
                
                VStack(spacing: 0) {
                    ForEach(Array(displayTexts.enumerated()), id: \.offset) { idx, line in
                        Text(line)
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
                            .frame(width: 358, alignment: .top)
                            .padding(.bottom, idx < displayTexts.count - 1 ? ViewSpacing.medium : 0)
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)
                .onAppear {
                    completedLines = totalTypeCount
                }
                
                Color.clear
                    .frame(height: 140)
                
                VStack(spacing: 0) {
                    HStack(alignment: .center, spacing: -2) {
                        SliderView(value: $sliderValue,
                                   minValue: 0, maxValue: 4,
                                   trackColor: Color(red: 0.4, green: 0.72, blue: 0.6),
                                   thumbInnerColor: Color(red: 0.4, green: 0.72, blue: 0.6),
                                   thumbOuterColor: Color(red: 0.96, green: 0.96, blue: 0.96),
                                   thumbInnerDiameter: 24,
                                   thumbOuterDiameter: 24)
                        .frame(width: 342, height: 8)
                        .onChange(of: sliderValue) { oldValue, newValue in
                            currentStep = Int(newValue) + 1
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Color.clear
                        .frame(height: 20)
                    
                    HStack(alignment: .center, spacing: -2) {
                        HStack(spacing: 0) {
                            ForEach(1...5, id: \.self) { number in
                                Text("\(number)")
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.82))
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
                
                Color.clear
                    .frame(height: 269)
                
                Button("继续") {
                    onContinue()
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .frame(width: 114, height: 44)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.full.value)
                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
                .font(Font.typography(.bodyMedium))
                .kerning(0.64)
                .multilineTextAlignment(.center)
                .padding(.bottom, 55)
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
            uiStyle: .styleSlider,
            texts: ["你觉得外部环境或者他人认可的因素，对于这件事的重要程度是多少呢？", "从1到5，为它打个分？"],
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
