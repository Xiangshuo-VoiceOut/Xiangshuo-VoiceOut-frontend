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

//#Preview {
//    GuiltQuestionPageView(
//        question: MoodTreatmentQuestion(
//            id: 1,
//            totalQuestions: 45,
//            type: .custom,
//            uiStyle: .styleA,
//            texts: [
//                "小云朵感受到了你现在有些心情不好，",
//                "我想要试着帮帮你呀。",
//                "可以告诉我，你现在感觉有多愤怒吗？"
//            ],
//            animation: nil,
//            options: [
//                .init(key: "A", text: "轻微生气/烦躁", next: 2,  exclusive: false),
//                .init(key: "B", text: "可控范围内的愤怒", next: 20, exclusive: false),
//                .init(key: "C", text: "非常愤怒影响生活", next: 54, exclusive: false)
//            ],
//            introTexts: [],
//            showSlider: false,
//            endingStyle: nil,
//            customViewName: "AngryQuestion1StyleView",
//            routine: "anger"
//        )
//    )
//    .environmentObject(RouterModel())
//}
