//
//  MatchingConsultantLandingView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/16/25.
//

import SwiftUI

struct MatchingConsultantLandingView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var progressViewModel = ProgressViewModel()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showExitPopup = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "匹配咨询师",
                    leadingComponent: AnyView(
                        Button(action: {
                            showExitPopup = true
                        }) {
                            Image("left-arrow")
                                .foregroundColor(.grey500)
                        }
                    ),
                    trailingComponent: nil
                )
                .frame(height: 44)

                contentView()
            }
        }
        .environmentObject(progressViewModel)
        .overlay(
            Group {
                if showExitPopup {
                    ExitPopupView(
                        didClose: {
                            showExitPopup = false
                            router.currentView = nil
                        },
                        continueMatching: {
                            showExitPopup = false
                        }
                    )
                    .transition(.opacity)
                    .animation(.easeInOut, value: showExitPopup)
                } else {
                    EmptyView()
                }
            }
        )
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if let currentView = router.currentView {
            switch currentView {
            case .singleChoice(let question, let surveyId, let surveyResultId):
                SingleChoiceQuestionView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
            case .rating(let question, let surveyId, let surveyResultId):
                RatingQuestionView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
            case .multipleChoice(let question, let surveyId, let surveyResultId, let nextQuestion):
                MultipleChoiceQuestionView(question: question, surveyId: surveyId, nextQuestion: nextQuestion, surveyResultId: surveyResultId)
            case .multipleChoiceEditable(let question, let surveyId, let surveyResultId):
                MultipleChoiceWithEditingView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
            case .resultView(let surveyResultId):
                MatchingConsultantResultView(surveyResultId: surveyResultId)
            default:
                EmptyView()
            }
        } else {
            welcomeView()
        }
    }

    private func welcomeView() -> some View {
        VStack(spacing: ViewSpacing.large) {
            HStack(alignment: .center) {
                Image("cloud2")
                    .frame(width: 166.21063, height: 96.20775)
                
                Spacer()
                
                Text("您好，\n感谢您来探索自我")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.grey300)
                    .padding(ViewSpacing.medium)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.medium.value)
            }
            .padding(.top, ViewSpacing.medium)
            
            ScrollView {
                VStack(alignment: .leading, spacing: ViewSpacing.large) {
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        Text("连接您的专属心理咨询师")
                            .font(.typography(.bodyLarge))
                            .foregroundColor(.grey500)
                            .padding(.leading, ViewSpacing.medium)
                        
                        Text("我们理解，面对心理健康问题时，找到合适的支持至关重要。为了帮助您找到最适合您当前需求的心理咨询师，我们设计了一份简短的问卷。请根据您的真实感受，诚实回答以下问题。您的回答将帮助我们更准确地了解您的情况，并推荐最适合您的心理咨询师。")
                            .font(.typography(.bodyMedium))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.grey300)
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                    }
                    
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        Text("开始问卷前，请记住")
                            .font(.typography(.bodyLarge))
                            .foregroundColor(.grey500)
                            .padding(.leading, ViewSpacing.medium)
                        
                        Text("\u{2022} 请根据您最近一个月的真实感受回答。\n\u{2022} 没有对错之分，我们关心的是您的真实体验。")
                            .font(.typography(.bodyMedium))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.grey300)
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("准备好了吗？让我们开始吧！")
                            .font(.typography(.bodyLargeEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .padding(.bottom, ViewSpacing.medium)
                        
                        Button(action: {
                            fetchFirstQuestion()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .frame(width: 358, height: 50)
                                    .background(Color.gray.opacity(0.5))
                                    .cornerRadius(CornerRadius.large.value)
                            } else {
                                ButtonView(
                                    text: "确定",
                                    action: {
                                        fetchFirstQuestion()
                                    },
                                    variant: .solid,
                                    theme: .action,
                                    fontSize: .medium,
                                    borderRadius: .full,
                                    maxWidth: 500
                                )
                            }
                        }
                        .disabled(isLoading)
                    }
                    .padding(.bottom, ViewSpacing.medium)
                }
                .frame(minHeight: UIScreen.main.bounds.height - 260)
            }
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private func fetchFirstQuestion() {
        isLoading = true
        errorMessage = nil

        let userId = "testUserId"

        MatchingConsultantService.fetchFirstQuestion(userId: userId) { response in
            DispatchQueue.main.async {
                isLoading = false
                
                guard let firstQuestion = response?.data.section else {
                    errorMessage = "无法获取第一道题，请稍后再试。"
                    return
                }

                let surveyId = response?.data.surveyId ?? ""
                let surveyResultId = response?.data.surveyResultId ?? ""

                DispatchQueue.main.async {
                    switch firstQuestion.optionsType {
                    case "single":
                        router.currentView = .singleChoice(question: firstQuestion, surveyId: surveyId, surveyResultId: surveyResultId)
                    case "scale":
                        router.currentView = .rating(question: firstQuestion, surveyId: surveyId, surveyResultId: surveyResultId)
                    case "multiple":
                        router.currentView = .multipleChoice(question: firstQuestion, surveyId: surveyId, surveyResultId: surveyResultId, nextQuestion: nil)
                    case "multiple-editable":
                        router.currentView = .multipleChoiceEditable(question: firstQuestion, surveyId: surveyId, surveyResultId: surveyResultId)
                    default:
                        print("❌ 未知问题类型")
                    }
                }
            }
        }
    }
}

#Preview {
    MatchingConsultantLandingView()
        .environmentObject(RouterModel())
}
