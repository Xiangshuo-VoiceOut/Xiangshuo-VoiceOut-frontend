//
//  MultipleChoiceQuestionView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/17/25.
//

import SwiftUI

struct MultipleChoiceQuestionView: View {
    @EnvironmentObject var router: RouterModel
    let question: Question
    let surveyId: String
    let nextQuestion: Question?
    let surveyResultId: String
    @State private var selectedOptions: [String] = []
    @State private var isNextEnabled: Bool = false
    @State private var totalQuestions: Int = 1
    @State private var showExitPopup = false

    @EnvironmentObject var progressViewModel: ProgressViewModel

    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {

                ProgressBarView(progressViewModel: progressViewModel)
                
                HStack {
                    Image("cloud2")
                        .frame(width: 166, height: 96)
                    Spacer()
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.top, 2 * ViewSpacing.betweenSmallAndBase)
                .padding(.bottom, 2 * ViewSpacing.betweenSmallAndBase)
                
                ScrollView {
                    VStack(spacing: ViewSpacing.large) {
                        HStack {
                            Text("\(question.sectionTitle)")
                                .font(.typography(.bodyLarge))
                                .foregroundColor(.grey300)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.medium)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                        
                        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                            ForEach(question.options, id: \._id) { option in
                                Button(action: {
                                    if selectedOptions.contains(option._id) {
                                        selectedOptions.removeAll { $0 == option._id }
                                    } else {
                                        selectedOptions.append(option._id)
                                    }
                                    isNextEnabled = !selectedOptions.isEmpty
                                }) {
                                    Text(option.optionText)
                                        .font(.typography(.bodyLarge))
                                        .foregroundColor(selectedOptions.contains(option._id) ? .textInvert : .grey300)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, ViewSpacing.medium)
                                }
                                .padding(.vertical, ViewSpacing.medium)
                                .frame(maxWidth: .infinity, minHeight: 56, alignment: .center)
                                .background(selectedOptions.contains(option._id) ? Color.surfaceBrandPrimary : Color.surfacePrimary)
                                .cornerRadius(CornerRadius.medium.value)
                            }
                        }
                        .padding(.top, ViewSpacing.large)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, ViewSpacing.medium)
                
                VStack(spacing: ViewSpacing.medium) {
                    HStack {
                        ButtonView(
                            text: "上一题",
                            action: {
                                submitAnswer(actionType: "prev")
                            },
                            variant: .outline,
                            theme: .base,
                            fontSize: .medium,
                            borderRadius: .full,
                            maxWidth: 117
                        )
                        
                        Spacer()
                        
                        ButtonView(
                            text: "下一题",
                            action: {
                                submitAnswer(actionType: "next")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    progressViewModel.updateProgress(currentIndex: question.sectionIndex, totalQuestions: question.totalQuestions)
                                }
                            },
                            variant: .solid,
                            theme: isNextEnabled ? .action : .bagdeInactive,
                            fontSize: .medium,
                            borderRadius: .full,
                            maxWidth: 225
                        )
                        .disabled(!isNextEnabled)
                    }
                }
                .padding(.vertical, ViewSpacing.medium)
                .padding(.horizontal, ViewSpacing.medium)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                if let total = question.totalQuestions, let index = question.sectionIndex {
                    let safeIndex = max(1, index)
                    progressViewModel.updateProgress(currentIndex: safeIndex, totalQuestions: total)
                }
            }
        }
        .overlay(
            Group {
                if showExitPopup {
                    ExitPopupView(
                        didClose: {
                            showExitPopup = false
                            router.popToRoot()
                        },
                        continueMatching: {
                            showExitPopup = false
                        }
                    )
                    .environmentObject(progressViewModel)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showExitPopup)
                } else {
                    EmptyView()
                }
            }
        )
    }
    
    private func submitAnswer(actionType: String) {
        guard !selectedOptions.isEmpty else {
            return
        }

        let totalScore = selectedOptions.reduce(0) { total, selectedOptionId in
            if let matchedOption = question.options.first(where: { $0._id == selectedOptionId }) {
                return total + matchedOption.score
            }
            return total
        }

        let selectedOptionsData: [[String: Any]] = [[
            "selectedOption": 0,
            "optionScore": totalScore
        ]]

        let requestBody: [String: Any] = [
            "surveyResultId": surveyResultId,
            "currentSectionId": question.sectionId,
            "action": actionType,
            "selectedOptions": selectedOptionsData
        ]

        MatchingConsultantService.fetchNextQuestion(requestBody: requestBody) { response in
            DispatchQueue.main.async {
                if let responseData = response?.data, let nextQuestion = responseData.section {
                    if let pageInfo = responseData.page, let totalQuestions = pageInfo.totalQuestions, let sectionIndex = nextQuestion.sectionIndex {
                        let safeIndex = max(1, sectionIndex)
                        progressViewModel.updateProgress(currentIndex: safeIndex, totalQuestions: totalQuestions)
                    }

                    navigateToNextQuestion(nextQuestion)
                } else {
                    router.navigateTo(.resultView(surveyResultId: surveyResultId))
                }
            }
        }
    }

    private func navigateToNextQuestion(_ nextQuestion: Question) {
        switch nextQuestion.optionsType {
        case "single":
            router.navigateTo(.singleChoice(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        case "scale":
            router.navigateTo(.rating(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        case "multiple":
            let hasOtherOption = nextQuestion.options.contains { $0.optionText == "其他" }
            if hasOtherOption {
                router.navigateTo(.multipleChoiceEditable(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
            } else {
                router.navigateTo(.multipleChoice(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId, nextQuestion: nil))
            }
        case "multiple-editable":
            router.navigateTo(.multipleChoiceEditable(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        default:
            print("❌ 未知问题类型: \(nextQuestion.optionsType)")
        }
    }
}

#Preview {
    MultipleChoiceQuestionView(
        question: Question(
            sectionId: 1,
            sectionTitle: "测试多选题",
            category: "测试",
            nextSection: nil,
            optionsType: "multiple",
            options: [
                Option(optionText: "选项 1", nextSection: nil, score: 0, _id: "1"),
                Option(optionText: "选项 2", nextSection: nil, score: 0, _id: "2")
            ],
            totalQuestions: 5
        ),
        surveyId: "test_id",
        nextQuestion: nil,
        surveyResultId: "test_survey_result_id"
    )
    .environmentObject(RouterModel())
    .environmentObject(ProgressViewModel())
}
