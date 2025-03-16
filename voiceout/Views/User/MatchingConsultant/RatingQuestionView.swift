//
//  RatingQuestionView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/20/25.
//

import SwiftUI

struct RatingQuestionView: View {
    @State private var selectedRating: Int? = nil
    @State private var isNextEnabled: Bool = false
    @State private var showExitPopup = false

    @EnvironmentObject var progressViewModel: ProgressViewModel
    let question: Question
    let surveyId: String
    let surveyResultId: String
    @EnvironmentObject var router: RouterModel

    let ratingOptions = [1, 2, 3, 4, 5]
    let descriptions = [
        1: "你感觉非常不符合",
        2: "你感觉比较不符合",
        3: "",
        4: "你感觉比较符合",
        5: "你感觉非常符合"
    ]

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

                HStack {
                    Text(question.sectionTitle)
                        .font(.typography(.bodyLarge))
                        .foregroundColor(.grey300)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                }
                .padding(.horizontal, ViewSpacing.medium)

                Spacer()

                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(height: 85)
                        .padding(.horizontal, ViewSpacing.medium)

                    HStack(spacing: ViewSpacing.small) {
                        ForEach(ratingOptions, id: \.self) { rating in
                            Button(action: {
                                selectedRating = rating
                                isNextEnabled = true
                            }) {
                                Text("\(rating)")
                                    .font(.typography(.bodyLarge))
                                    .frame(width: 64, height: 64)
                                    .background(selectedRating == rating ? Color.surfaceBrandPrimary : Color.white)
                                    .foregroundColor(selectedRating == rating ? .textInvert : .grey300)
                                    .cornerRadius(CornerRadius.xlarge.value)
                            }
                        }
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 85)

                if let selectedRating = selectedRating,
                   let description = descriptions[selectedRating],
                   !description.isEmpty {
                    Text(description)
                        .font(.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey200)
                        .frame(height: 24)
                        .padding(.top, ViewSpacing.small)
                } else {
                    Text("")
                        .font(.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.clear)
                        .frame(height: 24)
                        .padding(.top, ViewSpacing.small)
                }

                Spacer()

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
                        .padding(.leading, ViewSpacing.xxsmall)

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
            .background(Color.surfacePrimaryGrey2)
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
        guard let selectedScore = selectedRating else {
            return
        }

        let selectedOptionsData: [[String: Any]] = [
            [
                "selectedOption": 0,
                "optionScore": selectedScore
            ]
        ]

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
                    } else {
                    }

                    navigateToNextQuestion(nextQuestion)
                } else if let isNext = response?.data?.isNext, isNext == false {
                    router.navigateTo(.resultView(surveyResultId: surveyResultId))
                } else {
                }
            }
        }
    }


    private func navigateToNextQuestion(_ nextQuestion: Question) {
        DispatchQueue.main.async {
            self.selectedRating = nil
            self.isNextEnabled = false
        }

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
    RatingQuestionView(
        question: Question(
            sectionId: 1,
            sectionTitle: "测试问题",
            category: "测试",
            nextSection: nil,
            optionsType: "scale",
            options: [
                Option(optionText: "测试选项", nextSection: nil, score: 0, _id: "1")
            ],
            totalQuestions: 5
        ),
        surveyId: "test_id",
        surveyResultId: "test_survey_result_id"
    )
    .environmentObject(RouterModel())
    .environmentObject(ProgressViewModel())
}
