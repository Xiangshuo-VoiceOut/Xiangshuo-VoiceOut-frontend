//
//  AnxietyQuestionPageView.swift
//  voiceout
//
//  Created by Ziyang Ye on 10/15/25.
//

import SwiftUI

struct AnxietyQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()
    @State private var showExitPopup = false
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "anxiety"
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
        return q.uiStyle == .styleAnxietyEnding
        ? Color.surfaceBrandTertiaryPurple
        : Color.surfaceBrandTertiaryGreen
    }
    
    private var headerPlusProgressHeight: CGFloat {
        44 + 12 + 4 + 4 + 12
    }

    var body: some View {
        ZStack {
            fallbackBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "疗愈云港",
                    leadingComponent: AnyView(
                        (routine == "anxiety" && question?.uiStyle != .styleRank)
                        ? AnyView(Color.clear.frame(width: 24, height: 24))
                        : AnyView(BackButtonView().foregroundColor(.grey500))
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
        }
        .onChange(of: vm.question) { _, new in
            refreshProgress()
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let q = question {
            switch q.uiStyle {
            case .styleAnxietySinglechoice:
                AnxietyQuestionStyleSinglechoiceView(question: q, onSelect: handleSelectBackend)
            case .styleAnxietyMultichoice:
                AnxietyQuestionStyleMultichoiceView(question: q, onConfirm: handleConfirmMultichoice)
            case .styleAnxietyMatching:
                AnxietyQuestionStyleMatchingView(question: q, onConfirm: handleConfirmMatching)
            case .styleAnxietyEnding:
                AnxietyEndingView(question: q, onContinue: handleContinue)
            case .styleIntensificationVideo:
                RelaxationVideoView(question: q, onSelect: handleSelectBackend)
            case .styleTips:
                TipsView(question: q, onSelect: handleSelectBackend)
            default:
                // Fall back to common styles
                CommonQuestionStyles.view(for: q, onContinue: handleContinue, onSelect: handleSelectBackend,
                                          vm: vm)
            }
        } else {
            EmptyView()
        }
    }
    
    private func handleConfirmMultichoice(_ selected: [MoodTreatmentAnswerOption]) {
        selected.forEach { vm.submitAnswer(option: $0) }
        if let confirmOption = question?.options.first(where: { $0.exclusive == true }),
           let nextId = confirmOption.next {
            router.navigateTo(.anxietySingleQuestion(id: nextId))
        }
    }
    
    private func handleConfirmMatching(_ next: Int?) {
        if let nextId = next {
            router.navigateTo(.anxietySingleQuestion(id: nextId))
            return
        }
        if let nextId = question?.options.first(where: { $0.exclusive == true })?.next {
            router.navigateTo(.anxietySingleQuestion(id: nextId))
            return
        }
        if let currentId = question?.id {
            router.navigateTo(.anxietySingleQuestion(id: currentId + 1))
        }
    }
    
    private func handleSelectBackend(_ option: MoodTreatmentAnswerOption) {
        vm.submitAnswer(option: option)
        if let nextId = option.next {
            router.navigateTo(.anxietySingleQuestion(id: nextId))
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
                router.navigateTo(.anxietySingleQuestion(id: nextId))
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

#Preview("单选题") {
    AnxietyQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 10,
            uiStyle: .styleAnxietySinglechoice,
            texts: [
                "小云朵发现你似乎很紧张不安，",
                "能告诉我现在你是什么感受吗？"
            ],
            animation: nil,
            options: [
                .init(key: "1", text: "有点紧张，好像有点焦虑【轻度焦虑】", next: 2, exclusive: false),
                .init(key: "2", text: "感觉不安，已经影响到生活了【中度焦虑】", next: 3, exclusive: false),
                .init(key: "3", text: "控制不住的焦虑，感觉很糟糕。【重度焦虑】", next: 4, exclusive: false)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("多选题") {
    AnxietyQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 2,
            totalQuestions: 10,
            uiStyle: .styleAnxietyMultichoice,
            texts: [
                "此时此刻，你感到："
            ],
            animation: nil,
            options: [
                .init(key: "1", text: "身体紧绷", next: nil, exclusive: false),
                .init(key: "2", text: "呼吸不太顺畅", next: nil, exclusive: false),
                .init(key: "3", text: "心情烦躁", next: nil, exclusive: false),
                .init(key: "4", text: "一直在胡思乱想", next: nil, exclusive: false)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("配对题") {
    AnxietyQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 10,
            uiStyle: .styleAnxietyMatching,
            texts: [
                "然后，小云朵希望你能圈出自己具有的品德：",
                "哇！\n小云朵发现你真的有很多值得骄傲的地方呢！\n不要低估自己的闪光点，\n你已经拥有这么多优秀的品质啦。\n继续相信自己，\n这些品质会让你的生活更加精彩，\n也会带给身边的人温暖哦！",
                "小云朵想告诉你，\n其实你比你想象的更加优秀哦！\n有时候我们会忽略自己的优点，\n但它们真的在那里。\n再仔细看看，\n你还有哪些品质值得被肯定呢？\n给自己多一点鼓励，\n小云朵相信你有更多的闪光点等着被发现！"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("最终打分题") {
    AnxietyQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 10,
            totalQuestions: 10,
            uiStyle: .styleRank,
            texts: [
                "相比疗愈前，你现在的感受是"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        )
    )
    .environmentObject(RouterModel())
}

#Preview("结算动画页面") {
    AnxietyQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 100,
            totalQuestions: 100,
            uiStyle: .styleAnxietyEnding,
            texts: [
                "长按屏幕帮助小云朵整理焦虑吧！", 
                "不要抓着每一件事不放手，学会在合适的时候画上完美句号。学会允许事情进入人生，也要学会让它们离开。未完成和不完美，本就是生活的一部分。请接受和相信自己已经做得足够好了，调整和相信自己会变得更好。"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        )
    )
    .environmentObject(RouterModel())
}
