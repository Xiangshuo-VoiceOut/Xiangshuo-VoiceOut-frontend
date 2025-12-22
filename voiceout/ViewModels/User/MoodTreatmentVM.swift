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
                print(id)
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
    
    /// 提交疗愈结束时的评分
    func submitRating(routine: String, rating: Int) async -> Bool {
        do {
            _ = try await MoodTreatmentService.shared.submitRating(
                userId: userId,
                sessionId: sessionId,
                routine: routine,
                rating: rating
            )
            return true
        } catch {
            errorMessage = "Failed to submit rating：\(error.localizedDescription)"
            return false
        }
    }
}
