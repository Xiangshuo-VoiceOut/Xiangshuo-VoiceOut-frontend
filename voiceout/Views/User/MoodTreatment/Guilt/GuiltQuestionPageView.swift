//
//  GuiltQuestionPageView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/8/25.
//

import SwiftUI

struct GuiltQuestionPageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var vm = MoodTreatmentVM()
    @State private var showExitPopup = false
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "guilt"
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

                    Color.clear.frame(height: 12)
                    contentBody
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
        .onChange(of: vm.question) { new in
            refreshProgress()
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if let q = question {
            defaultSwitch(for: q)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func defaultSwitch(for q: MoodTreatmentQuestion) -> some View {
        switch q.uiStyle {
        case .guiltStyleA:
            GuiltQuestionStyleAView(question: q, onSelect: handleSelectBackend)
        case .guiltStyleB:
            GuiltQuestionStyleBView(
                question: q,
                onSelect: { _ in
                },
                onConfirm: { selected in
                    for opt in selected {
                        vm.submitAnswer(option: opt)
                    }
                    if let nextId = q.options.first(where: { $0.exclusive == true })?.next {
                        router.navigateTo(.guiltSingleQuestion(id: nextId))
                    }
                }
            )
        case .styleIntensificationVideo:
            RelaxationVideoView(question: q, onSelect: handleSelectBackend)
        default:
            // Fall back to common styles
            CommonQuestionStyles.view(for: q, onContinue: handleContinue, onSelect: handleSelectBackend,
                vm: vm)
        }
    }
    
    private func handleSelectBackend(_ option: MoodTreatmentAnswerOption) {
        vm.submitAnswer(option: option)
        if let nextId = option.next {
            router.navigateTo(.guiltSingleQuestion(id: nextId))
        }
    }
    
    private func handleContinue() {
        if let curr = question {
            let nextQuestionId = curr.options.first?.next ?? curr.id + 1
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

#Preview {
    GuiltQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            uiStyle: .guiltStyleA,
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
            customViewName: nil,
            routine: "guilt"
        )
    )
    .environmentObject(RouterModel())
}
