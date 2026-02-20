//
//  AngryQuestionStyleTimingView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI
import Lottie

struct CommonQuestionStyleBreatheView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    private let instructions = [
        "请放松从头顶到脚尖的肌肉，要特别注意你的面。"
    ]

    @State private var isPlayingMusic = true
    @State private var showFinalIntro = false
    @State private var showFinalButton = false
    @Binding var stepIndex: Int

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    Spacer()
                    if stepIndex == 0 {
                        footer
                    }
                }

                if stepIndex == 0 {
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()

                    VStack(spacing: ViewSpacing.large) {
                        TypewriterText(fullText: instructions[0], characterDelay: 0.1) { }
                            .font(Font.typography(.bodyMediumEmphasis))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.grey50)
                            .padding(.horizontal, 3*ViewSpacing.large)

                        LottieView(
                            animationName: "relaxing-bluecircle",
                            loopMode: .playOnce,
                            autoPlay: true,
                            onFinished: {},
                            speed: 1.2
                        )
                        .frame(width: 320, height: 320)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            stepIndex = 4
                        }
                    }
                }

                if stepIndex == 4 {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 144)
                        let firstLine = question.texts?.first ?? ""
                        TypewriterText(fullText: firstLine) {
                            showFinalIntro = true
                        }
                        .id("finalIntro")
                        .font(Font.typography(.bodySmall))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .padding(.bottom, ViewSpacing.large)

                        if showFinalIntro {
                            let secondLine = question.introTexts?.first ?? ""
                            TypewriterText(fullText: secondLine) {
                                showFinalButton = true
                            }
                            .id("finalHighlight")
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textBrandPrimary)
                            .padding(.bottom, ViewSpacing.large+ViewSpacing.xxxlarge)
                        }

                        if showFinalButton {
                            let option = question.options.first(where: { $0.exclusive == true })
                                ?? question.options.first
                            Button(option?.text ?? "")
                            {
                                if let opt = option {
                                    onSelect(opt)
                                }
                            }
                            .font(Font.typography(.bodyMedium))
                            .kerning(0.64)
                            .frame(width: 114, height: 44)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.full.value)
                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                            .padding(.top, ViewSpacing.medium)
                            .transition(.opacity)
                        }

                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
        }
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()
                Image("cloud-chat")
                    .resizable()
                    .frame(width: 168, height: 120)
                    .padding(.bottom, ViewSpacing.large)
                Spacer()
            }
            
//            MusicButtonView()
        }
    }
    
    private var footer: some View {
        Image("bucket")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}

struct CommonQuestionStyleBreatheView_Previews: PreviewProvider {
    static var previews: some View {
        let q = MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 45,
            uiStyle: .styleAngryTiming,
            texts: [
                "呼气时同样慢慢来，慢慢的在心中默数11秒"
            ],
            animation: "伸懒腰动画",
            options: [.init(key: "A", text: "我已经完成啦", next: 9, exclusive: true)],
            introTexts: ["请重复这个动作3次，直到你感觉充分放松"],
            showSlider: false,
            buttonTitle: "完成",
            endingStyle: nil,
            customViewName: "AngryQuestionStyleTimingView",
            routine: "Anger"
        )
        CommonQuestionStyleBreatheView(
            question: q,
            onSelect: { _ in },
            stepIndex: .constant(0)
        )
    }
}
