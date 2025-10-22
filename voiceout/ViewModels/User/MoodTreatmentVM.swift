//
//  MoodTreatmentVM.swift
//  voiceout
//
//  Created by Yujia Yang on 7/14/25.
//

import Foundation

@MainActor
final class MoodTreatmentVM: ObservableObject {
    @Published var question: MoodTreatmentQuestion?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let userId = "testuser"
    private let sessionId = "testsession"
    func loadQuestion(routine: String, id: Int) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let q = try await MoodTreatmentService.shared.fetchQuestion(routine: routine, id: id)
                question = q
            } catch {
                errorMessage = "Failed to load the question：\(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    func submitAnswer(option: MoodTreatmentAnswerOption) {
        guard let currentQuestion = question else {
            errorMessage = "The current question is empty"
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let nextQuestion = try await MoodTreatmentService.shared.submitAnswer(
                    userId: userId,
                    sessionId: sessionId,
                    questionId: currentQuestion.id,
                    selectedOptionKey: option.key
                )
                question = nextQuestion
            } catch {
                errorMessage = "Failed to submit answer：\(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func submitAnswerWithFallback(option: MoodTreatmentAnswerOption, fallback: ((Int) -> Void)?) {
        guard let currentQuestion = question else {
            self.errorMessage = "The current question is empty"
            if let nxt = option.next { fallback?(nxt) }
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let nextQuestion = try await MoodTreatmentService.shared.submitAnswer(
                    userId: userId,
                    sessionId: sessionId,
                    questionId: currentQuestion.id,
                    selectedOptionKey: option.key
                )
                self.question = nextQuestion
            } catch {
                self.errorMessage = "Failed to submit answer：\(error.localizedDescription)"
                if let nxt = option.next { fallback?(nxt) }
            }
            isLoading = false
        }
    }
    
    // 处理非选择题的数据提交（如便签、填空、情绪表达等）
    func submitContinueAction(questionId: Int, userData: [String: Any]? = nil) {
        guard let currentQuestion = question else {
            errorMessage = "The current question is empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // 创建提交数据
                var body: [String: Any] = [
                    "user_id": userId,
                    "session_id": sessionId,
                    "question_id": questionId,
                    "action": "continue"
                ]
                
                // 如果有用户数据，添加到提交中
                if let userData = userData {
                    body["user_data"] = userData
                }
                
                let nextQuestion = try await MoodTreatmentService.shared.submitCustomAnswer(body: body)
                question = nextQuestion
            } catch {
                errorMessage = "Failed to submit data：\(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
