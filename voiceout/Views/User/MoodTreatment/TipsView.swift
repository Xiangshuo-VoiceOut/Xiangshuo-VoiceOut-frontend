//
//  TipsView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/9/25.
//

import SwiftUI

struct TipsView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic: Bool = true
    @State private var showIntro: Bool = false
    @State private var showButton: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .frame(width:168,height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        HStack {
                            MusicButtonView()
                            Spacer()
                        }
                    }
                    .padding(.leading, ViewSpacing.medium)
                    
                    if let texts = question.texts {
                        ForEach(Array(texts.enumerated()), id: \.offset) { idx, line in
                            Text(line)
                                .font(Font.typography(.bodyMedium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey500)
                                .frame( alignment: .top)
                                .padding(.bottom, ViewSpacing.medium)
                                .onAppear {
                                    if idx == texts.count - 1 {
                                        if let highlights = question.introTexts, !highlights.isEmpty {
                                            showIntro = true
                                        } else {
                                            showButton = true
                                        }
                                    }
                                }
                        }
                    }
                    
                    VStack{
                        VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                            VStack(alignment: .center, spacing: ViewSpacing.medium) {
                                Text("身体的刚需")
                                    .font(Font.typography(.bodyMediumEmphasis))
                                    .foregroundColor(.textBrandPrimary)
                                    .frame(maxWidth: .infinity, alignment: .top)
                                
                                VStack(alignment: .leading, spacing: ViewSpacing.small) {
                                    Text("就像手机需要充电，汽车需要保养。")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    
                                    Text("我们的身体和大脑在高强度运转后，必须通过休息来进行修复、补充能量和整合信息。")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                    
                                    Text("剥夺休息，就是在透支未来的健康和效能。")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                }
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                        .padding(ViewSpacing.medium)
                        .frame(alignment: .topLeading)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                    }
                    .padding(.horizontal,ViewSpacing.xlarge)
                    .padding(.top,ViewSpacing.medium+ViewSpacing.large)
                    
                    Spacer()
                    
                    if showButton,
                       let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                        Button(action: {
                            onSelect(confirmOption)
                        }) {
                            Text(confirmOption.text)
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textBrandPrimary)
                                .frame(width: 114, height: 44)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .padding(.bottom, ViewSpacing.xxlarge-ViewSpacing.xxsmall)
                        .transition(.opacity)
                    }
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                type: .singleChoice,
                uiStyle: .styleB,
                texts: [
                    "我们常常将休息视为“不工作”的时间，\n甚至是生产力的对立面。\n但如果换个角度看呢？"
                ],
                animation: nil,
                options: [
                    .init(key: "A",text: "继续", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: nil,
                endingStyle: nil,
                routine: "anger"
            ),
            onSelect: { _ in }
        )
    }
}
