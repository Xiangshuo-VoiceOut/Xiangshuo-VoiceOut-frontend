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

    private var cancellables = Set<AnyCancellable>()

    func fetchFAQs() {
        guard let url = URL(string: "http://localhost:6500/api/faq") else {
            errorMessage = "Invalid API URL"
            return
        }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
            })
            .decode(type: FAQResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.faqCategories = response.data
            })
            .store(in: &cancellables)
    }
}
