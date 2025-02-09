//
//  BeforeFirstConsultationViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 1/13/25.
//

import Foundation
import Combine

class BeforeFirstConsultationViewModel: ObservableObject {
    @Published var steps: [FAQAnswer] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let faqService = FAQService()
    private var cancellables = Set<AnyCancellable>()

    func fetchConsultationSteps(questionID: String) {
        isLoading = true

        faqService.fetchConsultationSteps(questionID: questionID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let steps):
                    self?.steps = steps
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    private func handleError(_ error: FAQError) {
        switch error {
        case .invalidURL:
            errorMessage = "Invalid API URL"
        case .requestFailed:
            errorMessage = "Network request failed"
        case .decodingError:
            errorMessage = "Failed to decode response"
        default:
            errorMessage = "An unknown error occurred"
        }
    }
}
