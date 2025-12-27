//
//  ScareQuestionStyleBreatheView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/28/25.
//

import SwiftUI

struct ScareQuestionStyleBreatheView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic: Bool = true
    @State private var showIntro: Bool = false
    @State private var showButton: Bool = false
    @State private var selectedId: UUID? = nil
    @State private var showBoxGuide = false
    
    @Binding var isShowing478Guide: Bool
    @Binding var breatheStepIndex: Int
    
    private var demoStyleAQuestion: MoodTreatmentQuestion {
        MoodTreatmentQuestion(
            id: 10,
            totalQuestions: 45,
            uiStyle: .scareStyleA,
            texts: ["完成呼吸练习后，闭上眼睛，感受身体的变化。你的情绪是否有变得平静些呢？每次呼吸就想是一阵微风，吹散心里的乌云。小云朵会一直在你身边，陪着你走出不安。"],
            animation: nil,
            options: question.options,
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        )
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
//                        HStack {
//                            MusicButtonView()
//                            Spacer()
//                        }
                    }
                    .padding(.leading, ViewSpacing.medium)
                    
                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()), id: \.offset) { idx, line in
                        TypewriterText(
                            fullText: line
                        ) {
                            if idx == (question.texts?.count ?? 0) - 1 {
                                withAnimation(.easeIn(duration: 0.25)) { showIntro = true }
                            }
                        }
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                        .padding(.bottom, ViewSpacing.medium)
                    }
                    
                    if showIntro {
                        let breatheOptions = question.options.filter { $0.exclusive != true }
                        if !breatheOptions.isEmpty {
                            HStack(spacing: ViewSpacing.medium+ViewSpacing.large) {
                                ForEach(breatheOptions) { option in
                                    optionButton(option: option)
                                }
                            }
                            .padding(.horizontal, ViewSpacing.large)
                            .padding(.vertical, ViewSpacing.small)
                        }
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .overlay {
            if isShowing478Guide {
                Scare478BreatheGuideView(
                    isPresented: $isShowing478Guide,
                    stepIndex: $breatheStepIndex,
                    durations: [0, 4, 7, 8],
                    instructions: [
                        "放松，从一口深呼吸开始。放松全身的肌肉，从头到脚，将自己的注意力转移到呼吸上，舌尖轻贴上牙龈后方，准备好了我们就开始吧！",
                        "吸气——鼻子慢慢吸，像云朵一样慢慢鼓起来。用鼻子吸气4秒 ",
                        "屏住呼吸，轻轻地感受空气停留在身体里，屏住呼吸7秒。",
                        "慢慢吐气，像轻轻吹走一片云朵，用嘴巴慢慢呼气8秒。"
                    ],
                    styleAQuestion: demoStyleAQuestion,
                    onSelectNext: { selected in
                        onSelect(selected)
                    }
                )
                .zIndex(10)
            }
            
            if showBoxGuide {
                BoxBreathingGuideView(
                    isPresented: $showBoxGuide
                ) {
                }
                .zIndex(10)
            }
        }
    }
    
    @ViewBuilder
    private func optionButton(option: MoodTreatmentAnswerOption) -> some View {
        let isSelected = selectedId == option.id
        let capInsets = EdgeInsets(top: ViewSpacing.base, leading: ViewSpacing.base+ViewSpacing.medium, bottom: ViewSpacing.base, trailing: ViewSpacing.base+ViewSpacing.medium)
        let imageName = isSelected ? "bottle-option-selected" : "bottle-option-normal"
        
        Text(option.text)
            .font(Font.typography(.bodyMedium))
            .foregroundColor(.grey500)
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.leading, ViewSpacing.small)
            .padding(.vertical, ViewSpacing.base)
            .background(
                Image(imageName).resizable(capInsets: capInsets, resizingMode: .stretch)
            )
            .fixedSize(horizontal: false, vertical: true)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedId = option.id
                showButton = true
                switch option.key {
                case "A":
                    breatheStepIndex = 0
                    isShowing478Guide = true
                case "B":
                    showBoxGuide = true
                default:
                    onSelect(option)
                    break;
                }
            }
    }
}

struct ScareQuestionStyleBreatheView_Previews: PreviewProvider {
    @State static var isShowing478 = false
    @State static var breatheStep = 0
    
    static var previews: some View {
        ScareQuestionStyleBreatheView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                uiStyle: .scareStyleBreathe,
                texts: [
                    "深呼吸能帮助我们安抚情绪，放松身体，让害怕感慢慢变轻。\n选择一种你喜欢的呼吸节奏吧！"
                ],
                animation: nil,
                options: [
                    .init(key: "A", text: "478呼吸法", next: nil, exclusive: false),
                    .init(key: "B", text: "盒式呼吸法", next: nil, exclusive: false),
                    .init(key: "C", text: "我准备好了", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: nil,
                endingStyle: nil,
                routine: "scare"
            ),
            onSelect: { _ in },
            isShowing478Guide: $isShowing478,
            breatheStepIndex: $breatheStep
        )
    }
}
