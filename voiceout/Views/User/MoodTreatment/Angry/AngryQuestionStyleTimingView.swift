//
//  AngryQuestionStyleTimingView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI
import Lottie

struct AngryQuestionStyleTimingView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    private let durations = [0, 60, 7, 11]
    private let instructions = [
        "请放松从头顶到脚尖的肌肉，要特别注意你的面。",
        "让我们先闭上眼睛深呼吸，每次吸气和呼气都要超过5秒。请不要担心时间，1分钟后，我会负责提醒你的~",
        "当你做好准备时，下一次呼吸请非常缓慢地吸气，心中可以默数7秒钟",
        "呼气时同样慢慢来，慢慢的在心中默数11秒"
    ]

    @State private var remainingTime = 0
    @State private var isPlayingMusic = true
    @State private var timer: Timer?
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
                            stepIndex = 1
                        }
                    }
                }

                if (1...3).contains(stepIndex) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 144)
                        TypewriterText(fullText: instructions[stepIndex], characterDelay: 0.05) {
                            startTimer()
                        }
                        .id(stepIndex)
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.grey500)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)

                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.78, green: 0.91, blue: 0.96).opacity(0.2), lineWidth: 10)
                                .frame(width: 346, height: 346)
                            Circle()
                                .stroke(Color(red: 0.78, green: 0.91, blue: 0.96).opacity(0.5), lineWidth: 18)
                                .frame(width: 248, height: 248)
                            Circle()
                                .stroke(Color(red: 0.78, green: 0.91, blue: 0.96), lineWidth: 8)
                                .frame(width: 138, height: 138)
                            Text("\(remainingTime)")
                                .font(Font.typography(.headerMedium))
                                .monospacedDigit()
                                .foregroundColor(Color(red: 0.42, green: 0.81, blue: 0.95))
                        }
                        .frame(width: geo.size.width - 48, height: geo.size.width - 48)
                        .padding(.top, 3*ViewSpacing.betweenSmallAndBase)

                        Spacer()
                    }
                    .onAppear { remainingTime = durations[stepIndex] }
                    .onChange(of: stepIndex) { new in
                        if (1...3).contains(new) {
                            remainingTime = durations[new]
                        }
                    }
                }

                if stepIndex == 4 {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 144)
                        TypewriterText(fullText: "请重复这个动作3次，直到你感觉充分放松", characterDelay: 0.05) {
                            showFinalIntro = true
                        }
                        .id("finalIntro")
                        .font(Font.typography(.bodySmall))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .padding(.bottom, ViewSpacing.large)

                        if showFinalIntro {
                            TypewriterText(fullText: "完成后返回主页面继续下一步", characterDelay: 0.05) {
                                showFinalButton = true
                            }
                            .id("finalHighlight")
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textBrandPrimary)
                            .padding(.bottom, ViewSpacing.large+ViewSpacing.xxxlarge)
                        }

                        if showFinalButton {
                            let option = question.options.first(where: { $0.exclusive == true }) ?? question.options.first
                            Button(option?.text ?? "我已经完成啦") {
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
            .onAppear {
                if (1...3).contains(stepIndex) {
                    remainingTime = durations[stepIndex]
                } else {
                    remainingTime = 0
                }
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tm in
            remainingTime -= 1
            if remainingTime <= 0 {
                tm.invalidate()
                stepIndex += 1
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
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
            
            Button { isPlayingMusic.toggle() } label: {
                Image(isPlayingMusic ? "music" : "stop-music")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(.leading,ViewSpacing.medium)
            }
        }
    }
    
    private var footer: some View {
        Image("bucket")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}

struct AngryQuestionStyleTimingView_Previews: PreviewProvider {
    static var previews: some View {
        let q = MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 45,
            type: .custom,
            uiStyle: .styleAngryTiming,
            texts: [
                "接下来可以睁开眼睛，双手相握向上举起，像伸懒腰一样在头顶撑住再放松，手臂回到原位。",
                "请重复这个动作3次，直到你感觉充分放松。"
            ],
            animation: "伸懒腰动画",
            options: [.init(key: "A", text: "我已经完成啦", next: 9, exclusive: true)],
            introTexts: [],
            showSlider: false,
            buttonTitle: "完成",
            endingStyle: nil,
            customViewName: "AngryQuestionStyleTimingView",
            routine: "anger"
        )
        AngryQuestionStyleTimingView(
            question: q,
            onSelect: { _ in },
            stepIndex: .constant(4)
        )
    }
}
