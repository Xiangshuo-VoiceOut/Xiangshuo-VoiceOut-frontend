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
    
    private let questionId: Int?
    private let previewQuestion: MoodTreatmentQuestion?
    
    private var routine: String {
        (previewQuestion ?? vm.question)?.routine ?? "sad"
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

                contentBody
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
                SadQuestionStyleNotesView(question: q, onContinue: handleContinue)
            case .styleInteractiveDialogue:
                SadQuestionStyleInteractiveDialogueView(question: q, onContinue: handleContinue)
            case .styleMatching:
                SadQuestionStyleMatchingView(question: q, onContinue: handleContinue)
            case .styleUpload:
                SadQuestionStyleUploadView(question: q, onContinue: handleContinue)
            case .styleSlider:
                SadQuestionStyleSliderView(question: q, onContinue: handleContinue)
            case .styleMultichoice:
                SadQuestionStyleMultichoiceView(question: q, onContinue: handleContinue)
            case .styleFillInBlank:
                SadQuestionStyleFillInBlankView(question: q, onContinue: handleContinue)
            case .styleTodo:
                SadQuestionStyleTodoView(question: q, onContinue: handleContinue)
            case .styleEmotion:
                SadQuestionStyleEmotionView(question: q, onContinue: handleContinue)
            case .styleOrder:
                SadQuestionStyleOrderView(question: q, onContinue: handleContinue)
            case .styleEnd:
                SadQuestionStyleEndView(question: q, onContinue: handleContinue)
            default:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
    
    private func handleSelectBackend(_ option: MoodTreatmentAnswerOption) {
        vm.submitAnswer(option: option)
    }
    
    private func handleContinue() {
        // 对于非选择题，需要创建虚拟选项来提交数据
        if let currentQuestion = question {
            // 创建一个虚拟的选项来表示"继续"操作
            let continueOption = MoodTreatmentAnswerOption(
                key: "continue",
                text: "继续",
                next: currentQuestion.id + 1,
                exclusive: false
            )
            vm.submitAnswer(option: continueOption)
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
    SadQuestionPageView(
        question: MoodTreatmentQuestion(
            id: 12,
            totalQuestions: 12,
            type: .custom,
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
