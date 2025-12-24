//
//  ScareQuestionPageView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/26/25.
//

import SwiftUI

struct ScareQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()
    @State private var showExitPopup = false
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "fear"
    }
    
    init(questionId: Int) {
        self.questionId = questionId
        self.previewQuestion = nil
    }
    
    init(question: MoodTreatmentQuestion) {
        self.previewQuestion = question
        self.questionId = nil
    }
        
    @State private var showImageBackground = false
    @StateObject private var progressViewModel = ProgressViewModel()
    @State private var timingStepIndex: Int = 0
    @State private var isShowing478Guide = false
    @State private var breatheStepIndex = 0
    private var question: MoodTreatmentQuestion? {
        previewQuestion ?? vm.question
    }
    
    private var headerPlusProgressHeight: CGFloat {
        44 + 12 + 4 + 4 + 12
    }
    
    private func refreshProgress() {
        guard let q = question else { return }
        let total = max(q.totalQuestions ?? 0, 1)
        let current = min(max(q.id, 1), total)
        let ratio = CGFloat(current) / CGFloat(total)
        progressViewModel.progressWidth = progressViewModel.fullWidth * ratio
    }
    
    private var headerBgColor: Color {
        (question?.uiStyle == .scareStyleEnding) ? moodColors["scare"]! : .clear
    }

    private var fallbackBackground: Color {
        guard let q = question else { return Color.surfaceBrandTertiaryGreen }
        return q.uiStyle == .scareStyleEnding
            ? moodColors["scare"]!
            : Color.surfaceBrandTertiaryGreen
    }

    var body: some View {
        ZStack {
            Group {
                if let q = question, q.uiStyle == .scareStyleEnding, showImageBackground {
                    Image("scare-ending")
                        .resizable()
                        .scaledToFill()
                } else {
                    fallbackBackground
                }
            }
            .ignoresSafeArea()

            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    StickyHeaderView(
                        title: "疗愈云港",
                        leadingComponent: AnyView(
                            BackButtonView()
                                .foregroundColor(.grey500)
                        ),
                        trailingComponent: AnyView(
                            Button(action: {
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                    showExitPopup = true
                                }
                            }) {
                                Image("close")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.grey500)
                            }
                        ),
                        backgroundColor: .clear
                    )
                    .frame(height: 44)
                    .overlay {
                        if isShowing478Guide && breatheStepIndex == 0 {
                            Color.black.opacity(0.25).ignoresSafeArea()
                        }
                    }

//                    let totalWidth = UIScreen.main.bounds.width - 128
//                    
//                    ZStack(alignment: .leading) {
//                        Capsule()
//                            .fill(Color.surfacePrimary)
//                            .frame(width: totalWidth, height: 12)
//                        Capsule()
//                            .fill(Color.surfaceBrandPrimary)
//                            .frame(width: progressViewModel.progressWidth, height: 12)
//                    }
//                    .padding(.vertical, ViewSpacing.xsmall)
//                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .overlay {
                        if isShowing478Guide && breatheStepIndex == 0 {
                            Color.black.opacity(0.25).ignoresSafeArea()
                        }
                    }

                    Color.clear.frame(height: 12)
                        .overlay {
                            if isShowing478Guide && breatheStepIndex == 0 {
                                Color.black.opacity(0.25).ignoresSafeArea()
                            }
                        }
                    if question?.uiStyle != .styleAngryTiming {
                        contentBody
                    } else {
                        Spacer()
                    }
                }
                .background(headerBgColor)

            }
        }
        .overlay {
            ZStack {
                if showExitPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    ExitPopupCardView(
                        onExit: {
                            hidePopup()
                            router.navigateTo(.mainHomepage)
                        },
                        onContinue: { hidePopup() },
                        onClose: { hidePopup() }
                    )
                    .padding(.horizontal, ViewSpacing.xlarge)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.32, dampingFraction: 0.86), value: showExitPopup)
        }
        .onAppear {
            if previewQuestion == nil, let id = questionId {
                vm.loadQuestion(routine: routine, id: id)
            }
            progressViewModel.fullWidth = UIScreen.main.bounds.width - 128
            refreshProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showImageBackground = true
            }
        }
        .onChange(of: vm.question) { _ in
            refreshProgress()
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let q = question {
            switch q.uiStyle {
            case .scareStyleA:
                ScareQuestionStyleAView(question: q, onSelect: handleSelect)

            case .scareStyleB:
                ScareQuestionStyleBView(
                    question: q,
                    onSelect: { opt in },
                    onConfirm: { _ in
                        if let confirmOpt = q.options.first(where: { $0.exclusive == true }),
                           let nextId = confirmOpt.next {
                            router.navigateTo(.scareSingleQuestion(id: nextId))
                        }
                    }
                )
            case .scareStyleC:
                ScareQuestionStyleCView(question: q, onSelect: handleSelect)
            case .scareStyleD:
                ScareQuestionStyleDView(question: q, onSelect: handleSelect)
            case .scareStyleLocation:
                ScareQuestionStyleLocationView(question: q, onSelect: handleSelect)
            case .scareStyleBreathe:
                ScareQuestionStyleBreatheView(
                    question: q,
                    onSelect: handleSelect,
                    isShowing478Guide: $isShowing478Guide,
                    breatheStepIndex: $breatheStepIndex
                )
            case .scareStyleMoodWriting:
                ScareQuestionStyleMoodWritingView(question: q, onSelect: handleSelect)
            case .scareStyleBubble1:
                ScareQuestionStyleBubble1View(question: q, onSelect: handleSelect)
            case .scareStyleBubble2:
                ScareQuestionStyleBubble2View(question: q, onSelect: handleSelect)
            case .scareStyleTyping:
                ScareQuestionStyleTypingView(question: q, onSelect: handleSelect)
            case .scareStyleEnding:
                ScareEndingView(question: q)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            default:
                // Fall back to common styles
                CommonQuestionStyles.view(for: q, onContinue: handleContinue, onSelect: handleSelect,
                    vm: vm)
            }
        } else {
            EmptyView()
        }
    }
    private func hidePopup() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            showExitPopup = false
        }
    }
    private func handleSelect(_ option: MoodTreatmentAnswerOption) {
        guard let nxt = option.next else { return }
        router.navigateTo(.scareSingleQuestion(id: nxt))
    }
    
    private func handleContinue() {
        if let currentQuestion = question {
            let nextQuestionId = currentQuestion.options.first?.next ?? currentQuestion.id + 1
            let continueOption = MoodTreatmentAnswerOption(
                key: "continue",
                text: "继续",
                next: nextQuestionId,
                exclusive: false
            )
            vm.submitAnswer(option: continueOption)
            if let nextId = continueOption.next {
                router.navigateTo(.scareSingleQuestion(id: nextId))
            }
        }
    }
}

///single choice
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 1,
//            totalQuestions: 45,
//            uiStyle: .scareStyleA,
//            texts: ["现在，请感受一下自己的状态。",
//                    "你是否觉得自己正处于危险之中？"],
//            animation: nil,
//            options: [
//                .init(key: "A",text: "是的，我感到了不安全", next: 2, exclusive: false),
//                .init(key: "B",text: "没有，我目前觉得自己是安全的", next: 23, exclusive: false)
//            ],
//            introTexts: nil,
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///multichoice
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 99,
//            totalQuestions: 45,
//            uiStyle: .scareStyleB,
//            texts: ["在外面的世界，感觉有点不踏实是很正常的。",
//                    "我们先寻找一些可以让我们安心的东西，来帮助我们安心：你有注意到哪些让你熟悉或者安心的东西吗？"],
//            animation: nil,
//            options: [
//                .init(key: "A",text: "我以前来过这里", next: 100, exclusive: false),
//                .init(key: "B",text: "看到了熟悉的标志", next: 100, exclusive: false),
//                .init(key: "C",text: "周围的人群看起来很正常", next: 100, exclusive: false),
//                .init(key: "D",text: "看见了可爱的小动物", next: 100, exclusive: false),
//                .init(key: "E",text: "闻到了美食的味道", next: 100, exclusive: false),
//                .init(key: "F",text: "环境比较平静", next: 101, exclusive: false),
//                .init(key: "G",text: "我选好了", next: 101, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///slider
#Preview {
    ScareQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 45,
            uiStyle: .scareStyleC,
            texts: ["可以跟小云朵说下你的害怕程度吗？"],
            animation: nil,
            options: [
                .init(key: "A",text: "我选好了", next: 6, exclusive: true)
            ],
            introTexts: nil,
            showSlider: true,
            endingStyle: nil,
            customViewName: nil,
            routine: "scare"
        )
    )
    .environmentObject(RouterModel())
}

/// 云朵+黑文字+绿文字
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 7,
//            totalQuestions: 45,
//            uiStyle: .scareStyleD,
//            texts: [
//                "接下来我们做一组简单的情绪疏导练习，这能够使你的潜意识感受到安全的信号"
//            ],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "我准备好了", next: 8, exclusive: true)
//            ],
//            introTexts: [
//                "如果你愿意的话，可以先进入一个安全的环境里"
//            ],
//            showSlider: nil,
//            endingStyle: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// location
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 10,
//            totalQuestions: 45,
//            uiStyle: .scareStyleLocation,
//            texts: [
//                "我们先来描述一下你目前所处的环境，可以讲讲你现在在哪里、周围的情况是什么样的、有哪些人或物在你身边？"
//            ],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "我在自己家里，家里没人，还算安静", next: 6, exclusive: false),
//                .init(key: "B", text: "我不在家，但我在另外一个熟悉的地方", next: 6, exclusive: false),
//                .init(key: "C", text: "我在外面，有熟悉的人在身边", next: 12, exclusive: false),
//                .init(key: "D", text: "我在一个陌生的地方，心里不太踏实", next: 12, exclusive: false),
//                .init(key: "E", text: "我选好了", next: 5, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// breathe
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 11,
//            totalQuestions: 45,
//            uiStyle: .scareStyleBreathe,
//            texts: [
//                "深呼吸能帮助我们安抚情绪，放松身体，让害怕感慢慢变轻。\n选择一种你喜欢的呼吸节奏吧！"
//            ],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "478呼吸法", next: nil, exclusive: false),
//                .init(key: "B", text: "盒式呼吸法", next: nil, exclusive: false),
//                .init(key: "C", text: "我准备好了", next: 5, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///MoodWriting
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 1,
//            totalQuestions: 45,
//            uiStyle: .scareStyleMoodWriting,
//            texts: ["开始描述你的情绪。你感到害怕吗？还是其他感受？"],
//            animation: nil,
//            options: [.init(key: "A",text: "我选好了", next: 2, exclusive: true)],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///bottle
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 24,
//            totalQuestions: 45,
//            uiStyle: .scareStyleBottle,
//            texts: ["在进行积极自我对话之后，现在你是否感觉情绪平稳一些了呢？"],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "让漂流瓶顺着海洋飘走", next: 35, exclusive: false),
//                .init(key: "B", text: "写下害怕，再把它吹散", next: 36, exclusive: false)
//            ],
//            introTexts: [
//                "害怕表达自己的真实想法",
//                "害怕在公共场合讲话",
//                "害怕做出错误的选择",
//                "害怕自己不够优秀",
//                "其他"
//            ],
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// bubble1
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 24,
//            totalQuestions: 45,
//            uiStyle: .scareStyleBubble1,
//            texts: ["这些情绪对xxx的身体带来了什么影响呢？"],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "心跳加快", next: 35, exclusive: false),
//                .init(key: "B", text: "食欲减退", next: 36, exclusive: false),
//                .init(key: "C", text: "出汗", next: 37, exclusive: false),
//                .init(key: "D", text: "肠胃不舒服", next: 38, exclusive: false),
//                .init(key: "E", text: "记忆力减退", next: 39, exclusive: false),
//                .init(key: "F", text: "心情低落", next: 40, exclusive: false),
//                .init(key: "G", text: "减少社交", next: 41, exclusive: false),
//                .init(key: "H", text: "我选好了", next: 42, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// bubble2
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 25,
//            totalQuestions: 45,
//            uiStyle: .scareStyleBubble2,
//            texts: ["这些情绪对xxx的身体带来了什么影响呢？"],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "心跳加快", next: 35, exclusive: false),
//                .init(key: "B", text: "食欲减退", next: 36, exclusive: false),
//                .init(key: "C", text: "出汗", next: 37, exclusive: false),
//                .init(key: "D", text: "肠胃不舒服", next: 38, exclusive: false),
//                .init(key: "E", text: "记忆力减退", next: 39, exclusive: false),
//                .init(key: "F", text: "心情低落", next: 40, exclusive: false),
//                .init(key: "G", text: "减少社交", next: 41, exclusive: false),
//                .init(key: "H", text: "我选好了", next: 42, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// typing
//#Preview {
//    ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 26,
//            totalQuestions: 45,
//            uiStyle: .scareStyleTyping,
//            texts: [
//                "在我们感到脆弱和敏感的时候，可能是我们的内心需要更多的关爱。现在，可以跟我一起写下这几句话～"
//            ],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "我写好了", next: 50, exclusive: true)
//            ],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///ending
//#Preview {
//    let scareEndings = [
//        "你做得太好了，小云朵看见你一步步走出害怕的阴影，真的替你感到骄傲！如果愿意的话，可以在情绪日历上记下今天是勇敢的一天哦~",
//        "看，小害怕云慢慢变成了一朵软软的棉花糖云，心里是不是也暖暖的？以后再遇到类似的情绪，我们也可以这么温柔地照顾它。",
//        "你真的很棒，能够察觉害怕、面对它，再一点点让它变小，这就是勇气的样子呢。小云朵为你鼓掌~",
//        "害怕并不代表软弱，它只是想告诉你：“嘿，有些事我还没准备好。”你能静静听见它的声音，就是一种了不起的力量。"
//    ]
//    let randomEnding = scareEndings.randomElement()!
//
//    return ScareQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 999,
//            totalQuestions: 45,
//            uiStyle: .scareStyleEnding,
//            texts: [randomEnding],
//            animation: nil,
//            options: [],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "scare"
//        )
//    )
//    .environmentObject(RouterModel())
//}
