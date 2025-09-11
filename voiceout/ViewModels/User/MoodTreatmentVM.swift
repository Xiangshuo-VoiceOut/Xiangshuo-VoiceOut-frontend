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

    func loadQuestion(id: Int) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let q = try await MoodTreatmentService.shared.fetchQuestion(id: id)
                question = q
            } catch {
                errorMessage = "Failed to update：\(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
