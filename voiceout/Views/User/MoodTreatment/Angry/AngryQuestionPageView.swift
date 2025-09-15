//
//  AngryQuestionPageView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/14/25.
//

import SwiftUI

struct AngryQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()
    
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "anger"
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
    
    private var question: MoodTreatmentQuestion? {
        previewQuestion ?? vm.question
    }
    
    private var fallbackBackground: Color {
        guard let q = question else { return Color.surfaceBrandTertiaryGreen }
        return q.uiStyle == .styleAngryEnding
        ? (moodColors[routine] ?? Color.surfaceBrandTertiaryGreen)
        : Color.surfaceBrandTertiaryGreen
    }
    
    private var headerPlusProgressHeight: CGFloat {
        44 + 12 + 4 + 4 + 12
    }

    var body: some View {
        ZStack {
            Group {
                if let q = question, q.uiStyle == .styleAngryEnding, showImageBackground {
                    Image("angry-ending")
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
                        leadingComponent: AnyView(BackButtonView()
                            .foregroundColor(.grey500)),
                        trailingComponent: AnyView(
                            Button {} label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.grey500)
                            }
                        ),
                        backgroundColor: .clear
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

                    Color.clear.frame(height: 12)

                    if isTimingQuestion(question) {
                        Spacer()
                    } else {
                        contentBody
                    }
                }

                if isTimingUIStyle(question), timingStepIndex == 0 {
                    Color.black.opacity(0.25)
                        .frame(height: headerPlusProgressHeight + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
                        .edgesIgnoringSafeArea(.top)
                        .zIndex(1)
                }
            }

            if let q = question, isTimingQuestion(q) {
                VStack(spacing: 0) {
                    Spacer().frame(height: headerPlusProgressHeight)
                    AngryQuestionStyleTimingView(
                        question: q,
                        onSelect: handleSelectBackend,
                        stepIndex: $timingStepIndex
                    )
                    .ignoresSafeArea(edges: .horizontal)

                    Spacer()
                }
                .ignoresSafeArea(edges: .bottom)
                
                if timingStepIndex == 4 {
                    VStack {
                        Spacer()
                        Button(action: {
                            if let opt = q.options.first(where: { $0.exclusive == true }) ?? q.options.first {
                                vm.submitAnswerWithFallback(option: opt) { nxt in
                                    router.navigateTo(.angrySingleQuestion(id: nxt))
                                }
                            }
                        }) {
                            Rectangle()
                                .fill(Color.white.opacity(0.001))
                                .frame(height: 280)
                                .frame(maxWidth: .infinity)
                        }
                        .contentShape(Rectangle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea()
                    .allowsHitTesting(true)
                    .zIndex(99)
                }
            }
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
        .onChange(of: vm.question) { new in
            refreshProgress()
            if isTimingQuestion(new) {
                timingStepIndex = 0
            }
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let q = question {
            if let name = q.customViewName, name == "AngryQuestionStyleTimingView" {
                EmptyView()
            } else if let name = q.customViewName, name == "AngryQuestion1StyleView" {
                AngryQuestion1StyleView(question: q, onSelect: handleSelectBackend)
            } else {
                defaultSwitch(for: q)
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func defaultSwitch(for q: MoodTreatmentQuestion) -> some View {
        switch q.uiStyle {
        case .styleA:
            AngryQuestionStyleAView(question: q, onSelect: handleSelectBackend)
        case .styleB:
            AngryQuestionStyleBView(question: q, onSelect: handleSelectBackend)
        case .styleC:
            AngryQuestionStyleCView(question: q)
        case .styleD:
            let needCal = q.options.contains { $0.exclusive == true }
            AngryQuestionStyleDView(
                question: q,
                onButtonTap: {},
                onCalendarTap: needCal ? { router.navigateTo(.moodCalendar) } : nil
            )
        case .styleE:
            AngryQuestionStyleEView(
                question: q,
                onSelect: { _ in },
                onConfirm: { _ in
                    if let confirmOpt = q.options.first(where: { $0.exclusive == true }),
                       let nextId = confirmOpt.next {
                        router.navigateTo(.angrySingleQuestion(id: nextId))
                    }
                }
            )
        case .styleF:
            AngryQuestionStyleFView(
                questionTemplates: ["…"],
                onConfirm: { _ in },
                question: q,
                onSelect: { _ in }
            )
        case .styleG:
            AngryQuestionStyleGView(question: q, onSelect: handleSelectBackend)
        case .styleBottle:
            AngryQuestionStyleBottleView(
                question: q,
                onSelect: handleSelectBackend  
            )
        case .styleNote:
            AngryQuestionStyleNoteView(question: q, onSelect: handleSelectBackend)
        case .styleAngryEnding:
            AngryEndingView()
        default:
            EmptyView()
        }
    }
    
    private func handleSelectBackend(_ option: MoodTreatmentAnswerOption) {
        vm.submitAnswer(option: option)
    }
    
    private func refreshProgress() {
        guard let q = question else { return }
        let total = max(q.totalQuestions ?? 0, 1)
        let current = min(max(q.id, 1), total)
        let ratio = CGFloat(current) / CGFloat(total)
        progressViewModel.progressWidth = progressViewModel.fullWidth * ratio
    }
    private func isTimingUIStyle(_ q: MoodTreatmentQuestion?) -> Bool {
        guard let q = q else { return false }
        return q.uiStyle == .styleAngryTiming
    }
    private func isTimingQuestion(_ q: MoodTreatmentQuestion?) -> Bool {
        guard let q = q else { return false }
        return q.uiStyle == .styleAngryTiming || q.customViewName == "AngryQuestionStyleTimingView"
    }
}

#Preview {
    AngryQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            type: .custom,
            uiStyle: .styleA,
            texts: [
                "小云朵感受到了你现在有些心情不好，",
                "我想要试着帮帮你呀。",
                "可以告诉我，你现在感觉有多愤怒吗？"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "轻微生气/烦躁", next: 2,  exclusive: false),
                .init(key: "B", text: "可控范围内的愤怒", next: 20, exclusive: false),
                .init(key: "C", text: "非常愤怒影响生活", next: 54, exclusive: false)
            ],
            introTexts: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: "AngryQuestion1StyleView",
            routine: "anger"
        )
    )
    .environmentObject(RouterModel())
}

///single choice
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 1,
//            type: .singleChoice,
//            uiStyle: .styleA,
//            texts: ["可以告诉我，你现在感觉有多愤怒吗？",
//                    "小云朵感受到了你现在有些心情不好，",
//                    "我想要试着帮帮你呀。"],
//            animation: nil,
//            options: [
//                .init(text: "我只是感到轻微的生气或烦躁", next: 2, exclusive: false),
//                .init(text: "我感到愤怒，但是仍在自己的可控范围内", next: 23, exclusive: false),
//                .init(text: "我非常愤怒，情绪已经影响了日常生活", next: 54, exclusive: false)
//            ],
//            introTexts: nil
//        )
//    )
//    .environmentObject(RouterModel())
//}


///single choice with ai
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 2,
//            type: .singleChoice,
//            uiStyle: .styleA,
//            texts: ["这段关系本身是否就是让你产生愤怒情绪的源头呢？","请记住，不要重复陷入一个负面循环中~"],
//            animation: nil,
//            options: [
//                .init(text: "明白了，我想做出改变~可以结束疏导", next: 5, exclusive: false),
//                .init(text: "我不知道怎么脱离", next: 6, exclusive: true)
//            ],
//            introTexts: nil,
//            showBackButton: false
//        )
//    )
//    .environmentObject(RouterModel())
//}


///single choice
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 4,
//            type: .singleChoice,
//            uiStyle: .styleB,
//            texts: ["接下来我们做一组简单的情绪疏导练习，这能够使你的潜意识感受到安全的信号"],
//            animation: nil,
//            options: [
//                .init(text: "我准备好了", next: 5, exclusive: true)
//            ],
//            introTexts: ["如果你愿意的话，可以先进入一个安全的环境里"]
//        )
//    )
//    .environmentObject(RouterModel())
//}

///animationOnly
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 5,
//            type: .animationOnly,
//            uiStyle: .styleC,
//            texts: ["让我们先闭上眼睛深呼吸，每次吸气和呼气都要超过5秒。请不要担心时间，1分钟后，我会负责提醒你的~"],
//            animation: "relaxing-bluecircle",
//            options: [],
//            introTexts: nil,
//            showBackButton: false
//        )
//    )
//    .environmentObject(RouterModel())
//}

/// slider（styleD）+ 日历按钮 预览
//#Preview{
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 888,
//            type: .slider,
//            uiStyle: .styleD,
//            texts:       [],
//            animation:   nil,
//            options: [
//                .init(text: "心情管家-愤怒路线结束",
//                      next: nil,
//                      exclusive: false),
//                .init(text: "",
//                      next: nil,
//                      exclusive: true)
//            ],
//            introTexts:  [],
//            buttonTitle: "心情管家-愤怒路线结束"
//        )
//    )
//    .environmentObject(RouterModel())
//}

///multichoice
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 99,
//            type: .multiChoice,
//            uiStyle: .styleE,
//            texts: ["小云朵明白了~","如果你现在感到愤怒，可以告诉我身体是否出现了下列这些变化吗？（多选）"],
//            animation: nil,
//            options: [
//                .init(text: "肌肉处于紧绷状态", next: 100, exclusive: false),
//                .init(text: "脸颊变红、体温升高、内部像要爆炸", next: 100, exclusive: false),
//                .init(text: "无法控制的流泪", next: 100, exclusive: false),
//                .init(text: "牙齿咬紧，或攥紧拳头", next: 100, exclusive: false),
//                .init(text: "想要扔东西、砸墙，或者伤害某些人事物", next: 100, exclusive: false),
//                .init(text: "其实，我现在没有这些感觉！", next: 101, exclusive: true)
//            ],
//            introTexts: nil,
//            showBackButton: false
//        )
//    )
//    .environmentObject(RouterModel())
//}

///fillInBlank
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 1000,
//            type: .fillInBlank,
//            uiStyle: .styleF,
//            texts: ["首先，请记住每一次你回想起令你感到愤怒的情景，情绪涌上来，都是又回到了那一刻，这是在重复伤害自己~","我希望能帮你能用其他方法疏解生气的感觉。","请和我一起回到当下，此时此刻："],
//            animation: nil,
//            options: [
//                .init(text: "下一步", next: 1001, exclusive: false)
//            ],
//            introTexts: ["我希望能帮你用其他方法疏解生气的感觉。"],
//            showBackButton: true
//        )
//    )
//    .environmentObject(RouterModel())
//}

///openText
//#Preview {
//    let gQuestion = MoodTreatmentQuestion(
//        id: 4,
//        type: .openText,
//        uiStyle: .styleG,
//        texts: ["看来你已经整理好心中各个方案的排序了，可以给我展示看看你想尝试的一种吗？"],
//        animation: nil,
//        options: [
//            .init(text: "完成", next: 5, exclusive: true)
//        ],
//        introTexts: nil,
//        showBackButton: false
//    )
//    AngryQuestionPageView(question: gQuestion)
//        .environmentObject(RouterModel())
//}

///bottle
//#Preview {
//    let bottleQuestion = MoodTreatmentQuestion(
//        id: 100,
//        type: .singleChoice,
//        uiStyle: .styleBottle,
//        texts: [""],
//        animation: nil,
//        options: [],
//        introTexts: [
//            "现在我感到生气是完全合理的，但是更重要且有利的是保持头脑冷静，思维清醒，并作出最佳的判断。",
//            "我不希望看到的事情出现了，这个状况使我的情绪波动，但我足够强大，可以接受已经发生的事实，所以没关系。",
//            "我不会让这件事，或这个人影响自己的情绪。我才是掌控自己身体和心灵的主人。",
//            "我不能掌控他人的想法或行为。他们有自己选择的路要走。世界也并不会永远按照我的想法运转，这很正常。",
//            "我愿意给自己一点时间，温和的处理愤怒情绪，现在并不需要决定任何事。",
//            "现状使人不满，但是我接下来会选择让事情朝着好的方向发展。我有信心，也足够有能力应对未来。"
//        ],
//        showBackButton: false
//    )
//    AngryQuestionPageView(question: bottleQuestion)
//        .environmentObject(RouterModel())
//}

///note
//#Preview {
//    let noteQuestion = MoodTreatmentQuestion(
//        id: 123,
//        type: .singleChoice,
//        uiStyle: .styleNote,
//        texts: ["接下来，挑一个你喜欢的便签，把这件令人生气的事情写下来吧~"],
//        animation: "bubble-breaking",
//        options: [],
//        introTexts: ["把这件令人生气的事情写下来吧~"],
//        showBackButton: false
//    )
//    AngryQuestionPageView(question: noteQuestion)
//        .environmentObject(RouterModel())
//}

///end view
//#Preview {
//    AngryQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 999,
//            type: .custom,
//            uiStyle: .styleAngryEnding,
//            texts: [],
//            animation: nil,
//            options: [],
//            introTexts: nil,
//            showBackButton: false
//        )
//    )
//    .environmentObject(RouterModel())
//}
