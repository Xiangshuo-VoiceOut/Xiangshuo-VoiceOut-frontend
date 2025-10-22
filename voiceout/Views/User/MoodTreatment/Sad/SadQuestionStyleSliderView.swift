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
    
    @State private var sliderValue = 0.5
    @State private var isPlayingMusic = true
    @State private var completedLines = 0
    
    private let typingInterval: TimeInterval = 0.08
    
    private var displayTexts: [String] {
        if let texts = question.texts, !texts.isEmpty {
            return texts
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
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 168)
                            .padding(.bottom, ViewSpacing.large)
                        Spacer()
                    }
                    
                    Button { isPlayingMusic.toggle() } label: {
                        Image(isPlayingMusic ? "music" : "stop-music")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    .padding(.leading, ViewSpacing.medium)
                }
                
                ForEach(Array(displayTexts.enumerated()), id: \.offset) { idx, line in
                    TypewriterText(fullText: line,
                                   characterDelay: typingInterval) {
                        completedLines += 1
                    }
                    .font(.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grey500)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.bottom, ViewSpacing.medium)
                }
                
                Spacer()
                
                if completedLines >= totalTypeCount {
                    VStack(spacing: 0) {
                        SliderView(value: $sliderValue,
                                   minValue: 0, maxValue: 1,
                                   trackColor: .surfaceBrandPrimary,
                                   thumbInnerColor: .surfaceBrandPrimary,
                                   thumbOuterColor: .surfacePrimaryGrey2,
                                   thumbInnerDiameter: 12,
                                   thumbOuterDiameter: 16)
                        .frame(height: 16)
                        
                        HStack {
                            Text("不重要")
                                .font(.typography(.bodyXXSmall))
                                .foregroundColor(.textLight)
                            Spacer()
                            Text("很重要")
                                .font(.typography(.bodyXXSmall))
                                .foregroundColor(.textLight)
                        }
                    }
                    .padding(.horizontal, ViewSpacing.large)
                    
                    VStack(spacing: ViewSpacing.large) {
                        Button {
                            onContinue()
                        } label: {
                            Text("继续")
                                .font(.typography(.bodyMedium))
                                .kerning(0.64)
                                .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.vertical, ViewSpacing.small)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .padding(.top, 7*ViewSpacing.betweenSmallAndBase)
                    }
                    .padding(.bottom, ViewSpacing.xlarge+ViewSpacing.xxxlarge)
                }
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
