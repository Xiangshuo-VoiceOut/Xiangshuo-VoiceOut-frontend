//
//  BoxBreathingGuideView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/9/25.
//

import SwiftUI

struct BoxBreathingGuideView: View {
    @Binding var isPresented: Bool
    let onFinish: () -> Void

    private enum BoxPhase: Int { case intro, inhale, hold1, exhale, hold2, complete }
    private let segmentSeconds: TimeInterval = 4
    private let totalSeconds: TimeInterval = 16
    private let tileAnimDuration: TimeInterval = 0.8
    private let lottieSpeed: CGFloat = 0.25
    private let headerReserve: CGFloat = 96
    @State private var phase: BoxPhase = .intro
    @State private var showTopIntro = false
    @State private var showTiles = false
    @State private var showBottomTip = false
    @State private var showStartButton = false
    @State private var showFinishStyleA = false
    @State private var tileSizes: [CGFloat] = [88, 88, 88, 88]
    @State private var tileBgOpacities: [Double] = [1, 1, 1, 1]
    private let brandFill = Color(red: 0.42, green: 0.81, blue: 0.95).opacity(0.25)
    private let idleSize: CGFloat = 88
    @State private var scheduledWork: [DispatchWorkItem] = []
    init(isPresented: Binding<Bool>, onFinish: @escaping () -> Void) {
        self._isPresented = isPresented
        self.onFinish = onFinish
    }

    private var headerText: String {
        switch phase {
        case .intro:
            return "稳定的节奏，稳定的心。\n盒式呼吸有四个相等的阶段，每个阶段 4 秒：吸气，屏息，呼气，再次屏息。"
        case .inhale:
            return "吸气—用鼻子吸气，感受身体充满空气"
        case .hold1:
            return "屏住呼吸，就像一切暂停片刻"
        case .exhale:
            return "呼气—慢慢将气息从嘴里吐出"
        case .hold2:
            return "再屏住一下呼吸，准备下一轮"
        case .complete:
            return ""
        }
    }

    var body: some View {
        ZStack {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea(edges: .bottom)

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
                    HStack {
                        MusicButtonView()
                        Spacer()
                    }
                }
                .padding(.leading, ViewSpacing.medium)

                ZStack {
                    if phase == .intro {
                        if showTopIntro {
                            TypewriterText(fullText: headerText) {
                                withAnimation(.easeIn(duration: 0.25)) { showTiles = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation(.easeIn(duration: 0.25)) { showBottomTip = true }
                                }
                            }
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 2*ViewSpacing.xlarge)
                            .padding(.bottom, ViewSpacing.medium)
                            .transition(.opacity)
                        } else {
                            Color.clear.frame(height: 1).onAppear { showTopIntro = true }
                        }
                    } else if phase != .complete {
                        Text(headerText)
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, ViewSpacing.medium+ViewSpacing.large)
                            .padding(.bottom, ViewSpacing.base)
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: headerReserve, alignment: .bottom)

                Group {
                    if isPracticePhase {
                        LottieView(
                            animationName: "breathe",
                            loopMode: .loop,
                            autoPlay: true,
                            onFinished: { },
                            speed: lottieSpeed
                        )
                        .frame(width: 260, height: 260)
                        .transition(.opacity)
                    } else {
                        tilesGrid
                            .opacity(showTiles ? 1 : 0)
                            .transition(.opacity)
                    }
                }
                .padding(.top, ViewSpacing.xxsmall+ViewSpacing.xsmall)
                .padding(.bottom, ViewSpacing.base)
                .animation(.easeInOut(duration: 0.25), value: isPracticePhase)
                .animation(.easeInOut(duration: 0.25), value: showTiles)

                Spacer(minLength: 8)

                if phase == .intro, showBottomTip {
                    TypewriterText(fullText: "找个安静的地方，坐下或躺下，准备好了我们就开始吧！") {
                        withAnimation(.easeIn(duration: 0.25)) { showStartButton = true }
                    }
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grey500)
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.bottom, ViewSpacing.small)
                    .transition(.opacity)
                }

                if phase == .intro, showStartButton {
                    Button("开始练习") {
                        startPractice()
                    }
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textBrandPrimary)
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(height: 44)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.full.value)
                    .padding(.top, ViewSpacing.xsmall)
                    .transition(.opacity)
                }

                Spacer()
            }

            if showFinishStyleA {
                Color.black.opacity(0.25).ignoresSafeArea()

                ScareQuestionStyleAView(
                    question: finishQuestion,
                    onSelect: handleFinishSelection
                )
                .transition(.opacity)
                .zIndex(20)
            }
        }
        .onDisappear { cancelScheduled() }
    }

    private var isPracticePhase: Bool {
        phase == .inhale || phase == .hold1 || phase == .exhale || phase == .hold2
    }

    private func startPractice() {
        cancelScheduled()
        phase = .inhale
        schedule(after: segmentSeconds)   { self.phase = .hold1 }
        schedule(after: segmentSeconds*2) { self.phase = .exhale }
        schedule(after: segmentSeconds*3) { self.phase = .hold2 }
        schedule(after: totalSeconds)     {
            self.phase = .complete
            self.showFinishStyleA = true
        }
    }

    private func schedule(after delay: TimeInterval, _ block: @escaping () -> Void) {
        let item = DispatchWorkItem(block: block)
        scheduledWork.append(item)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    private func cancelScheduled() {
        scheduledWork.forEach { $0.cancel() }
        scheduledWork.removeAll()
    }

    private var tilesGrid: some View {
        VStack(spacing: ViewSpacing.large+ViewSpacing.xlarge) {
            HStack(spacing: ViewSpacing.large+ViewSpacing.xlarge) {
                labeledTile(title: "吸气", index: 0)
                labeledTile(title: "屏息", index: 1)
            }
            HStack(spacing: ViewSpacing.large+ViewSpacing.xlarge) {
                labeledTile(title: "呼气", index: 2)
                labeledTile(title: "再次屏息", index: 3)
            }
        }
        .onAppear {
            if phase == .intro {
                tileSizes = [idleSize, idleSize, idleSize, idleSize]
                tileBgOpacities = [1, 1, 1, 1]
            }
        }
    }

    private func labeledTile(title: String, index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius:CornerRadius.small.value)
                .fill(brandFill)
                .opacity(tileBgOpacities[index])
                .animation(.easeInOut(duration: tileAnimDuration), value: tileBgOpacities[index])

            Text(title)
                .font(index == 3 ? Font.typography(.bodyLargeEmphasis) : Font.typography(.headerSmall))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.42, green: 0.81, blue: 0.95))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(width: tileSizes[index], height: tileSizes[index])
        .animation(.easeInOut(duration: tileAnimDuration), value: tileSizes[index])
    }

    private var finishQuestion: MoodTreatmentQuestion {
        MoodTreatmentQuestion(
            id: 21,
            totalQuestions: 45,
            type: .singleChoice,
            uiStyle: .scareStyleA,
            texts: ["小云朵提示", "一轮盒式呼吸完成了！还想继续吗？"],
            animation: nil,
            options: [
                .init(key: "A",text: "再来一轮", next: 2101, exclusive: false),
                .init(key: "B",text: "我完成了", next: 2200, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        )
    }

    private func handleFinishSelection(_ option: MoodTreatmentAnswerOption) {
        if option.text == "再来一轮" {
            showFinishStyleA = false
            cancelScheduled()
            phase = .intro
            showTopIntro = false
            showTiles = false
            showBottomTip = false
            showStartButton = false
            DispatchQueue.main.async { showTopIntro = true }
        } else {
            showFinishStyleA = false
            isPresented = false
            onFinish()
        }
    }
}

#Preview("Scare Box Breathing") {
    BoxBreathingGuideView(isPresented: .constant(true)) { }
}
