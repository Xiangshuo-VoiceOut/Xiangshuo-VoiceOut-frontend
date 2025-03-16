//
//  MultipleChoiceWithEditingView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/20/25.
//

import SwiftUI

struct MultipleChoiceWithEditingView: View {
    @EnvironmentObject var router: RouterModel
    let question: Question
    let surveyId: String
    let surveyResultId: String
    @State private var selectedOptions: Set<String> = []
    @State private var otherText: String = ""
    @State private var isOtherSelected: Bool = false
    @State private var isEditingOther: Bool = false
    @State private var isNextEnabled: Bool = false
    @FocusState private var isTextFieldFocused: Bool
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
                        .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                            ForEach(question.options, id: \._id) { option in
                                if option.optionText == "其他" {
                                    renderOtherOption()
                                } else {
                                    OptionButton(
                                        option: option.optionText,
                                        isSelected: selectedOptions.contains(option.optionText),
                                        showEditIcon: false
                                    ) {
                                        toggleSelection(option.optionText)
                                    }
                                }
                            }
                        }
                        .padding(.top, ViewSpacing.large)
                    }
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
                .padding(ViewSpacing.medium)
            }
        }
        .onAppear {
            initializeOtherOption()
            DispatchQueue.main.async {
                if let total = question.totalQuestions, let index = question.sectionIndex {
                    let safeIndex = max(1, index)
                    progressViewModel.updateProgress(currentIndex: safeIndex, totalQuestions: total)
                } else {
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
    
    private func renderOtherOption() -> some View {
        VStack {
            if isEditingOther {
                HStack {
                    Image("edit")
                        .foregroundColor(.grey200)
                        .frame(width: 24, height: 24)
                    
                    TextField("其他...", text: $otherText, onCommit: {
                        if !otherText.isEmpty {
                            isEditingOther = false
                            isOtherSelected = true
                            selectedOptions.insert(otherText)
                            updateNextButtonState()
                        }
                    })
                    .font(.typography(.bodyLarge))
                    .foregroundColor(.grey200)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                }
                .padding()
                .background(Color.surfacePrimaryGrey)
                .cornerRadius(CornerRadius.medium.value)
            } else {
                OptionButton(
                    option: otherText.isEmpty ? "其他" : otherText,
                    isSelected: isOtherSelected,
                    showEditIcon: true
                ) {
                    isEditingOther = true
                    isTextFieldFocused = true
                }
            }
        }
    }
    
    private func toggleSelection(_ option: String) {
        if option == "其他" || option == otherText {
            isEditingOther = true
        } else {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        }
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        isNextEnabled = !selectedOptions.isEmpty || (!otherText.isEmpty && isOtherSelected)
    }
    
    private func initializeOtherOption() {
        if let otherOption = question.answer?.other, !otherOption.isEmpty {
            otherText = otherOption
            isOtherSelected = true
            selectedOptions.insert(otherOption)
        }
    }
    
    private func submitAnswer(actionType: String) {
        let totalScore = selectedOptions.reduce(0) { total, selectedOptionId in
            if let matchedOption = question.options.first(where: { $0._id == selectedOptionId }) {
                return total + matchedOption.score
            } else {
                return total + 1
            }
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
                    } else {
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
            router.navigateTo(.multipleChoice(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId, nextQuestion: nil))
        case "multiple-editable":
            router.navigateTo(.multipleChoiceEditable(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        default:
            print("❌ 未知问题类型: \(nextQuestion.optionsType)")
        }
    }
}

struct OptionButton: View {
    let option: String
    let isSelected: Bool
    let showEditIcon: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if showEditIcon {
                    Image("edit")
                        .foregroundColor(.grey200)
                        .frame(width: 24, height: 24)
                }
                Text(option)
                    .font(.typography(.bodyLarge))
                    .foregroundColor(isSelected ? .textInvert : .grey300)
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.medium)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.surfaceBrandPrimary : Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
        }
    }
}

#Preview {
    MultipleChoiceWithEditingView(
        question: Question(
            sectionId: 1,
            sectionTitle: "测试可自定义多选",
            category: "测试",
            nextSection: nil,
            optionsType: "multiple-editable",
            options: [
                Option(optionText: "选项 1", nextSection: nil, score: 0, _id: "1"),
                Option(optionText: "选项 2", nextSection: nil, score: 0, _id: "2"),
                Option(optionText: "其他", nextSection: nil, score: 1, _id: "3")
            ],
            totalQuestions: 5,
            answer: Answer(other: "")
        ),
        surveyId: "test_id",
        surveyResultId: "test_survey_result_id"
    )
    .environmentObject(RouterModel())
    .environmentObject(ProgressViewModel())
}
