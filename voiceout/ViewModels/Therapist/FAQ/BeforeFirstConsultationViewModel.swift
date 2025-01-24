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

    private var cancellables = Set<AnyCancellable>()

    func fetchConsultationSteps(questionID: String) {
        guard let url = URL(string: "http://localhost:6500/api/faq/\(questionID)") else {
            errorMessage = "Invalid API URL"
            return
        }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FAQQuestion.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { question in
                self.steps = question.answers
            })
            .store(in: &cancellables)
    }
}
