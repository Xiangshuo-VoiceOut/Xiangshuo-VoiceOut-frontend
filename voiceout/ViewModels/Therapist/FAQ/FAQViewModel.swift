//
//  FAQViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 1/13/25.
//

import Foundation
import Combine

class FAQViewModel: ObservableObject {
    @Published var faqCategories: [FAQCategory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let faqService = FAQService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchFAQs() {
        isLoading = true

        faqService.fetchFAQs { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let categories):
                    self?.faqCategories = categories
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
