//
//  SadQuestionPageView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/18/25.
//

import SwiftUI

struct SadQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()
    @State private var showExitPopup = false
    @State private var timingStepIndex: Int = 0
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "sadness"
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
    
    private var question: MoodTreatmentQuestion? {
        previewQuestion ?? vm.question
    }
    
    private var fallbackBackground: Color {
        guard let q = question else { return Color.surfaceBrandTertiaryGreen }
        return q.uiStyle == .styleEnd
        ? (moodColors[routine] ?? Color.surfaceBrandTertiaryGreen)
        : Color.surfaceBrandTertiaryGreen
    }
    
    private var headerPlusProgressHeight: CGFloat {
        44 + 12 + 4 + 4 + 12
    }

    var body: some View {
        ZStack {
            Group {
                if let q = question, q.uiStyle == .styleEnd, showImageBackground {
                    VStack {
                        Spacer()
                        Image("windmill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                    }
                } else {
                    fallbackBackground
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "疗愈云港",
                    leadingComponent: AnyView(
                        (question?.uiStyle == .styleUpload || question?.uiStyle == .styleInteractiveDialogue || question?.uiStyle == .styleFillInBlank || question?.uiStyle == .styleSlider || question?.uiStyle == .styleMatching || question?.uiStyle == .styleNotes) ? AnyView(
                            Color.clear.frame(width: 24, height: 24)
                        ) : AnyView(BackButtonView()
                            .foregroundColor(.grey500))
                    ),
                    trailingComponent: AnyView(
                        Button {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                showExitPopup = true
                            }
                        } label: {
                            Image("close")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.grey500)
                        }
                    ),
                    backgroundColor: .clear
                )
                .frame(height: 44)

//                let totalWidth = UIScreen.main.bounds.width - 128
//                
//                ZStack(alignment: .leading) {
//                    Capsule()
//                        .fill(Color.surfacePrimary)
//                        .frame(width: totalWidth, height: 12)
//                    Capsule()
//                        .fill(Color.surfaceBrandPrimary)
//                        .frame(width: progressViewModel.progressWidth, height: 12)
//                }
//                .padding(.vertical, ViewSpacing.xsmall)
//                .padding(.horizontal, 2*ViewSpacing.xlarge)

                Color.clear.frame(height: 12)

                contentBody
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
        .onChange(of: vm.question) { _, new in
            refreshProgress()
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let q = question {
            switch q.uiStyle {
            case .styleSinglechoice:
                SadQuestionStyleSinglechoiceView(question: q, onSelect: handleSelectBackend)
            case .styleNotes:
                SadQuestionStyleNotesView(question: q,onSelect: handleSelectBackend)
            case .styleMultichoice:
                SadQuestionStyleMultichoiceView(question: q, onContinue: handleContinue)
            case .styleMultichoice2:
                SadQuestionStyleMultichoice2View(question: q, onContinue: handleContinue)
            case .styleTodo:
                SadQuestionStyleTodoView(question: q, onContinue: handleContinue)
            case .styleEmotion:
                SadQuestionStyleEmotionView(question: q, onContinue: handleContinue)
            case .styleOrder:
                SadQuestionStyleOrderView(question: q, onContinue: handleContinue)
            case .styleEnd:
                SadQuestionStyleEndView(question: q, onContinue: handleContinue)
            case .styleIntensificationVideo:
                RelaxationVideoView(question: q, onSelect: handleSelectBackend)
            case .styleAngryTiming:
                AngryQuestionStyleTimingView(
                    question: q,
                    onSelect: handleSelectBackend,
                    stepIndex: $timingStepIndex
                )
            case .scareStyleMoodWriting:
                ScareQuestionStyleMoodWritingView(
                    question: q,
                    onSelect: handleSelectBackend
                )
            case .styleNote:
                AngryQuestionStyleNoteView(
                    question: q,
                    onSelect: handleSelectBackend
                )
            default:
                // Fall back to common styles
                CommonQuestionStyles.view(for: q, onContinue: handleContinue, onSelect: handleSelectBackend,
                                          vm: vm)
            }
        } else {
            EmptyView()
        }
    }
    
    private func handleSelectBackend(_ option: MoodTreatmentAnswerOption) {
        vm.submitAnswer(option: option)
        if let nextId = option.next {
            router.navigateTo(.sadSingleQuestion(id: nextId))
        }
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
                router.navigateTo(.sadSingleQuestion(id: nextId))
            }
        }
    }
    private func hidePopup() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            showExitPopup = false
        }
    }
    private func refreshProgress() {
        guard let q = question else { return }
        let total = max(q.totalQuestions ?? 0, 1)
        let current = min(max(q.id, 1), total)
        let ratio = CGFloat(current) / CGFloat(total)
        progressViewModel.progressWidth = progressViewModel.fullWidth * ratio
    }
}

#Preview("结束页") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 12,
            totalQuestions: 12,
            uiStyle: .styleEnd,
            texts: ["你已经收集足够多的风啦，长按屏幕帮助小云朵吧！"],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("上传互动题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 12,
            uiStyle: .styleUpload,
            texts: ["和小云朵分享一下生活中的小美好吧，让心情慢慢明亮起来吧！"],
            animation: nil,
            options: [],
            introTexts: ["请上传一张今天吃到的好吃的"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("互动对话题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 6,
            totalQuestions: 12,
            uiStyle: .styleInteractiveDialogue,
            texts: ["尝试和小云朵一起探索拓宽的社交场合， 寻找更多志同道合的朋友吧！"],
            animation: nil,
            options: [
                .init(key: "A", text: "继续", next: 4, exclusive: true)
            ],
            introTexts: ["接下来， 你有没有一直很想尝试， 但是一直没有尝试的新技能或者新的想要探索的场所？ 请写下一个告诉我吧！"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("填空题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 7,
            totalQuestions: 12,
            uiStyle: .styleFillInBlank,
            texts: ["和小云朵想一想，这些'不足'是否也有他们的意义呢？🤔"],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}


#Preview("打分题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 8,
            totalQuestions: 12,
            uiStyle: .styleSlider,
            texts: ["请为你的心情打分"],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: true,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("配对题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 9,
            totalQuestions: 12,
            uiStyle: .styleMatching,
            texts: [
                "然后，小云朵希望你能圈出自己具有的品德：",
                "哇！\n小云朵发现你真的有很多值得骄傲的地方呢！\n不要低估自己的闪光点，\n你已经拥有这么多优秀的品质啦。\n继续相信自己，\n这些品质会让你的生活更加精彩，\n也会带给身边的人温暖哦！",
                "小云朵想告诉你，\n其实你比你想象的更加优秀哦！\n有时候我们会忽略自己的优点，\n但它们真的在那里。\n再仔细看看，\n你还有哪些品质值得被肯定呢？\n给自己多一点鼓励，\n小云朵相信你有更多的闪光点等着被发现！"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "责任感", next: nil, exclusive: false),
                .init(key: "B", text: "诚实", next: nil, exclusive: false),
                .init(key: "C", text: "善良", next: nil, exclusive: false),
                .init(key: "D", text: "独立", next: nil, exclusive: false),
                .init(key: "E", text: "宽容", next: nil, exclusive: false),
                .init(key: "F", text: "同情心", next: nil, exclusive: false),
                .init(key: "G", text: "正义感", next: nil, exclusive: false),
                .init(key: "H", text: "感恩", next: nil, exclusive: false),
                .init(key: "I", text: "礼貌", next: nil, exclusive: false)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}


#Preview("便签题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 10,
            totalQuestions: 12,
            uiStyle: .styleNotes,
            texts: [
                "和小云朵一起给自己创建一个短期目标吧！",
                "想想最近有什么想要完成的事情嘛，",
                "可以试着把这个当成一个短期目标去努力哦！"
            ],
            animation: nil,
            options: [],
            introTexts: ["或者试试这些短期目标呢"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("单选题") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 12,
            uiStyle: .styleSinglechoice,
            texts: [
                "小云朵闻到了下雨的预兆，",
                "可以跟小云朵说说，",
                "你的失落程度现在是哪一种吗？"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "我有一点轻微的难过（轻度）", next: 2, exclusive: false),
                .init(key: "B", text: "我很伤心，这已经影响到了正常生活（中度）", next: 3, exclusive: false),
                .init(key: "C", text: "我完全沉浸于负面情绪里（重度）", next: 4, exclusive: false)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("多选2") {
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 11,
            totalQuestions: 12,
            uiStyle: .styleMultichoice2,
            texts: [
                "Xxx是否有一些一直坚持的习惯呢？",
                "愿意跟小云朵分享一下吗？（多选）"
            ],
            animation: nil,
            options: [
                .init(key: "A", text: "健身", next: nil, exclusive: false),
                .init(key: "B", text: "球类运动", next: nil, exclusive: false),
                .init(key: "C", text: "画画", next: nil, exclusive: false),
                .init(key: "D", text: "看书", next: nil, exclusive: false),
                .init(key: "E", text: "早上一杯温水", next: nil, exclusive: false),
                .init(key: "F", text: "瑜伽", next: nil, exclusive: false)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        )
    )
    .environmentObject(RouterModel())
}
