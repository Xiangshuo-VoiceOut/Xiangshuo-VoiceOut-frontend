//
//  EnvyQuestionPageView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/28/25.
//

import SwiftUI

struct EnvyQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()

    private let questionId: Int
    private let previewQuestion: MoodTreatmentQuestion?

    init(questionId: Int) {
        self.questionId = questionId
        self.previewQuestion = nil
    }
    init(question: MoodTreatmentQuestion) {
        self.questionId = question.id
        self.previewQuestion = question
    }

    @StateObject private var progressViewModel = ProgressViewModel()

    private var currentQuestion: MoodTreatmentQuestion? {
        previewQuestion ?? vm.question
    }
    private var routine: String {
        previewQuestion?.routine ?? "envy"
    }

    private var headerColor: Color {
        guard let q = currentQuestion else { return Color.surfaceBrandTertiaryGreen }
        return (q.uiStyle == .styleEnvyFinalEnding || q.uiStyle == .styleEnvyEnding)
            ? Color(moodColors["envy"]!)
            : Color.surfaceBrandTertiaryGreen
    }

    var body: some View {
        Group {
            if let question = currentQuestion {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        StickyHeaderView(
                            title: "疗愈云港",
                            leadingComponent: AnyView(
                                BackButtonView()
                                    .foregroundColor(.grey500)
                            ),
                            trailingComponent: AnyView(
                                Button(action: { }) {
                                    Image("close")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.grey500)
                                }
                            ),
                            backgroundColor: headerColor
                        )
                        .frame(height: 44)

                        let totalWidth = UIScreen.main.bounds.width - 128
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.surfacePrimary)
                                .frame(width: totalWidth, height: 12)
                            Capsule()
                                .fill(Color.surfaceBrandPrimary)
                                .frame(width: progressViewModel.progressWidth, height: 12)
                        }
                        .padding(.vertical, ViewSpacing.xsmall)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                        .background(headerColor)
                    }

                    Rectangle()
                        .fill(headerColor)
                        .frame(height: 12)

                    VStack(spacing: 0) {
                        switch question.uiStyle {
                        case .styleH:
                            EnvyQuestionStyleHView(
                                question: question,
                                onSelect: handleSelect
                            )
                        case .styleI:
                            EnvyQuestionStyleIView(
                                question: question,
                                onSelect: { _ in },
                                onConfirm: { _ in router.navigateBack() }
                            )
                        case .styleJ:
                            EnvyQuestionStyleJView(
                                question: question,
                                onSelect: { option in
                                    if option.next == nil {
                                        router.navigateBack()
                                    }
                                }
                            )
                        case .styleScrollDown:
                            EnvyQuestionStyleScrollDownView(
                                question: question,
                                onSelect: { option in
                                    if option.next == nil {
                                        router.navigateBack()
                                    }
                                }
                            )
                        case .styleMirror:
                            EnvyQuestionStyleMirrorView(
                                question: question,
                                requiredSelections: question.id == 5 ? 1 : nil,
                                onSelect: { option in
                                    if option.next == nil {
                                        router.navigateBack()
                                    }
                                }
                            )

                        case .styleTyping:
                            EnvyQuestionStyleTypingView(
                                question: question,
                                onSelect: { _ in }
                            )
                        case .styleEnvyFinalEnding:
                            EnvyFinalEndingView()
                        case .styleEnvyEnding:
                            EnvyEndingView(question: question)
                        default:
                            EmptyView()
                        }
                    }
                }
                .background(Color.surfaceBrandTertiaryGreen)
                .onAppear {
                    progressViewModel.fullWidth = UIScreen.main.bounds.width - 128
                    progressViewModel.updateProgress(currentIndex: 3, totalQuestions: 10)
                }

            } else if vm.isLoading {
                ProgressView("Loading…")
            } else if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .onAppear {
            if previewQuestion == nil {
                vm.loadQuestion(routine: routine, id: questionId)
            }
        }
    }

    private func handleSelect(_ option: MoodTreatmentAnswerOption) {
        guard let nextId = option.next else { return }
        router.navigateTo(.envySingleQuestion(id: nextId))
    }
}

///sigle choice
#Preview {
    let sampleQuestion = MoodTreatmentQuestion(
        id: 1,
        totalQuestions: 100,
        type: .singleChoice,
        uiStyle: .styleH,
        texts: ["可以跟小云朵说说你的嫉妒程度吗？"],
        animation: nil,
        options: [
            .init(key: "A",text: " 我心里已经产生了敌意，偏见，厌恶，甚至怨恨。已经开始在语言或行为上伤害对方", next: 2, exclusive: false),
            .init(key: "B",text: "产生内耗情绪，常想着与对方竞争比较，以此渴望证明自己", next: 3, exclusive: false),
            .init(key: "C",text: "轻微嫉妒。偶尔发生，并不放在心里。没有对别人产生偏见或采取行动影响对方", next: 10, exclusive: false)
        ],
        introTexts: nil,
        showSlider: nil,
        endingStyle: nil,
        customViewName: nil,
        routine: "envy"
    )

    EnvyQuestionPageView(question: sampleQuestion)
        .environmentObject(RouterModel())
}

///multichoice
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 4,
//        totalQuestions: 100,
//        type: .multiChoice,
//        uiStyle: .styleI,
//        texts: ["可以跟小云朵说说你是因为什么而感到嫉妒的吗？"],
//        animation: nil,
//        options:  [
//            .init(key: "A",text: "我没有别人的外貌，身材", next: nil, exclusive: false),
//            .init(key: "B",text: "家庭不够优越", next: nil, exclusive: false),
//            .init(key: "C",text: "我没有一技之长", next: nil, exclusive: false),
//            .init(key: "D",text: "别人能力更强", next: nil, exclusive: false),
//            .init(key: "E",text: "如果有别人的一半幸运就好了", next: nil, exclusive: false),
//            .init(key: "F",text: "在群体里不受欢迎", next: nil, exclusive: false),
//            .init(key: "G",text: "其它", next: nil, exclusive: false),
//            .init(key: "H",text: "我选好了", next: nil, exclusive: true)
//        ],
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

/// scrolldown
//#Preview {
//    let sampleScroll = MoodTreatmentQuestion(
//        id: 4,
//        totalQuestions: 100,
//        type: .custom,
//        uiStyle: .styleScrollDown,
//        texts: ["你觉得自己最近的脆弱和敏感是由哪些事情引发的？"],
//        animation: nil,
//        options: [.init(key: "A",text: "我选好了", next: 5, exclusive: true)],
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//    EnvyQuestionPageView(question: sampleScroll)
//        .environmentObject(RouterModel())
//}

///ai
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 4,
//        totalQuestions: 100,
//        type: .singleChoice,
//        uiStyle: .styleJ,
//        texts: ["你可以简单说说，你怎么看待ta？你最关注ta的哪些方面？"],
//        animation: nil,
//        options: [
//            .init(key: "A",text: " 试试和小云聊聊天", next: 5, exclusive: true)
//        ],
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

///镜子碎片
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 4,
//        totalQuestions: 100,
//        type: .singleChoice,
//        uiStyle: .styleMirror,
//        texts: [
//            "当你感到嫉妒时，你内心相信自己也能够实现类似的成就。现在，请选择你觉得自己擅长或已取得成就的方面吧！"
//        ],
//        animation: nil,
//        options: [
//            .init(key: "A",text: "工作/事业发展", next: nil, exclusive: false),
//            .init(key: "B",text: "朋友/人际关系", next: nil, exclusive: false),
//            .init(key: "C",text: "克服困难", next: nil, exclusive: false),
//            .init(key: "D",text: "学业/专业技能提升", next: nil, exclusive: false),
//            .init(key: "E",text: "情绪管理/心理成长", next: nil, exclusive: false),
//            .init(key: "F",text: "独立生活能力", next: nil, exclusive: false),
//            .init(key: "G",text: "兴趣爱好", next: nil, exclusive: false),
//            .init(key: "H",text: "运动/健康习惯", next: nil, exclusive: false),
//            .init(key: "I",text: "帮助过他人", next: nil, exclusive: false),
//            .init(key: "J",text: "其他", next: nil, exclusive: false),
//            .init(key: "K",text: "我选好了", next: nil, exclusive: true)
//        ],
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

///多选（任意1）
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 5,
//        totalQuestions: 100,
//        type: .multiChoice,
//        uiStyle: .styleMirror,
//        texts: ["有哪些个人成长的目标是你可以通过自己的努力实现的？"],
//        animation: nil,
//        options: EnvyQuestionStyleMirrorView_Previews.anyMultiOptions,
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

///多选（必选3）
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 6,
//        totalQuestions: 100,
//        type: .multiChoice,
//        uiStyle: .styleMirror,
//        texts: ["选出三件你现在生活中感到感激的事物："],
//        animation: nil,
//        options: EnvyQuestionStyleMirrorView_Previews.threeMultiOptions,
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        customViewName: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

///打字
//#Preview {
//    let sampleQuestion = MoodTreatmentQuestion(
//        id: 1,
//        totalQuestions: 100,
//        type: .singleChoice,
//        uiStyle: .styleTyping,
//        texts: ["在我们感到脆弱和敏感的时候，可能是我们的内心需要更多的关爱。现在，可以跟我一起写下这几句话～"],
//        animation: nil,
//        options: [.init(key: "A",text: "我写好了", next: nil, exclusive: true) ],
//        introTexts: nil,
//        showSlider: nil,
//        endingStyle: nil,
//        routine: "envy"
//    )
//
//    EnvyQuestionPageView(question: sampleQuestion)
//        .environmentObject(RouterModel())
//}

/// final end view
//#Preview {
//    EnvyQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 999,
//            totalQuestions: 100,
//            type: .custom,
//            uiStyle: .styleEnvyFinalEnding,
//            texts: [],
//            animation: nil,
//            options: [],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            routine: "envy"
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// end view
//#Preview {
//    EnvyQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 999,
//            totalQuestions: 100,
//            type: .custom,
//            uiStyle: .styleEnvyEnding,
//            texts: ["愿你像小云朵一样，每天找到新的美好，装满自己的小天空。"],
//            animation: nil,
//            options: [],
//            introTexts: nil,
//            showSlider: nil,
//            endingStyle: nil,
//            customViewName: nil,
//            routine: "envy"
//        )
//    )
//    .environmentObject(RouterModel())
//}
