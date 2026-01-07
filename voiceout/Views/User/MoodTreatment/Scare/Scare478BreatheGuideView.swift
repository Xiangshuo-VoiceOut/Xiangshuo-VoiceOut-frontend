//
//  Scare478BreatheGuideView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/9/25.
//

import SwiftUI
import Lottie

struct Scare478BreatheGuideView: View {
    @Binding var isPresented: Bool
    @Binding var stepIndex: Int
    let durations: [Int]
    let instructions: [String]

    var styleAQuestion: MoodTreatmentQuestion?
    var onSelectNext: ((MoodTreatmentAnswerOption) -> Void)?

    @State private var remainingTime: Int = 0
    @State private var timer: Timer?

    init(isPresented: Binding<Bool>,
         stepIndex: Binding<Int>,
         durations: [Int],
         instructions: [String],
         styleAQuestion: MoodTreatmentQuestion? = nil,
         onSelectNext: ((MoodTreatmentAnswerOption) -> Void)? = nil) {
        self._isPresented = isPresented
        self._stepIndex = stepIndex
        self.durations = durations
        self.instructions = instructions
        self.styleAQuestion = styleAQuestion
        self.onSelectNext = onSelectNext
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.surfaceBrandTertiaryGreen.ignoresSafeArea()

                if stepIndex != 4 {
                    VStack {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        Spacer()
                    }
                }

                if stepIndex == 0 {
                    Color.black.opacity(0.25).ignoresSafeArea()

                    VStack(spacing: ViewSpacing.large) {
                        TypewriterText(
                            fullText: instructions[safe: 0] ?? ""
                        ) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                stopTimer()
                                stepIndex = 1
                                remainingTime = durations[safe: 1] ?? 0
                            }
                        }
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
                        stopTimer()
                    }
                }

                if (1...3).contains(stepIndex) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 144)

                        TypewriterText(
                            fullText: instructions[safe: stepIndex] ?? ""
                        ) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                stopTimer()
                                startTimer()
                            }
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
                    .onAppear {
                        remainingTime = durations[safe: stepIndex] ?? 0
                        stopTimer()
                    }
                    .onChange(of: stepIndex) { newValue in
                        if (1...3).contains(newValue) {
                            remainingTime = durations[safe: newValue] ?? 0
                            stopTimer()
                        }
                    }
                }

                if stepIndex == 4 {
                    let finishNext =
                        styleAQuestion?.options.first(where: { $0.key == "B" })?.next
                        ?? styleAQuestion?.options.first(where: { $0.exclusive == true })?.next
                    ScareQuestionStyleAView(
                        question: MoodTreatmentQuestion(
                            id: 9,
                            totalQuestions: 45,
                            uiStyle: .scareStyleA,
                            texts: [
                                "好棒！这是一次完整的呼吸练习。我们可以再来几轮，或者继续前进。"
                            ],
                            animation: nil,
                            options: [
                                .init(key: "A", text: "再来一轮", next: nil, exclusive: false),
                                .init(
                                    key: "B",
                                    text: "我完成了",
                                    next: finishNext,
                                    exclusive: true
                                )
                            ],
                            introTexts: nil,
                            showSlider: nil,
                            endingStyle: nil,
                            routine: "scare"
                        )
                    ) { opt in
                        switch opt.key {
                        case "A":
                            stepIndex = 0
                        case "B":
                            onSelectNext?(opt)
                            DispatchQueue.main.async {
                                isPresented = false
                            }
                        default:
                            break
                        }
                    }
                    .transition(.opacity)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func startTimer() {
        stopTimer()
        guard (1...3).contains(stepIndex) else { return }
        if remainingTime <= 0 { remainingTime = durations[safe: stepIndex] ?? 0 }

        let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tm in
            remainingTime -= 1
            if remainingTime <= 0 {
                tm.invalidate()
                timer = nil
                if stepIndex < 3 {
                    stepIndex += 1
                } else {
                    stepIndex = 4
                }
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    @State var isPresented = true
    @State var stepIndex = 0
    
    return Scare478BreatheGuideView(
        isPresented: $isPresented,
        stepIndex: $stepIndex,
        durations: [0, 4, 7, 8],
        instructions: [
            "放松，从一口深呼吸开始。放松全身的肌肉，从头到脚，将自己的注意力转移到呼吸上，舌尖轻贴上牙龈后方，准备好了我们就开始吧！",
            "吸气——鼻子慢慢吸，像云朵一样慢慢鼓起来。用鼻子吸气4秒 ",
            "屏住呼吸，轻轻地感受空气停留在身体里，屏住呼吸7秒。",
            "慢慢吐气，像轻轻吹走一片云朵，用嘴巴慢慢呼气8秒。"
        ],
        styleAQuestion: MoodTreatmentQuestion(
            id: 21,
            totalQuestions: 45,
            uiStyle: .scareStyleA,
            texts: ["小云朵提示", "一轮 478 呼吸完成了！还想继续吗？"],
            animation: nil,
            options: [
                .init(key: "A", text: "再来一轮", next: 2101, exclusive: false),
                .init(key: "B", text: "我完成了", next: 2200, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        ),
        onSelectNext: { opt in
        }
    )
    .environmentObject(RouterModel())
}
