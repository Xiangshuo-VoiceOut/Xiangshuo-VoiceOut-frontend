//
//  CommentCardViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 7/5/24.
//

import Foundation

class CommentCardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userComments: [Comment] = []

    func loadTestData() {
        let testPerformance = Performance(
            understanding: 4,
            adviceProvided: 5,
            professionalKnowledge: 4,
            attitude: 5
        )
        let testComment = Comment(
            _id: "1",
            userId: "62c1d9988ab92b1ac4e7dabc",
            clinicianId: "62c1d9988ab92b1ac4e7eabc",
            overallSatisfaction: 2,
            performance: testPerformance,
            likelyToContinue: 5,
            feedback: "老师很温暖，气场温和，跟他聊天非常愉快!",
            status: 2,
            profilePicture: "https://s3-alpha-sig.figma.com/img/cc95/6287/bb02dcd901a19d4857fdc3ed4d9ae631?Expires=1733097600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OQ2oS~AjsCNhOuhXQ-Ft4F1F~OHuvzqRY8r5C7lPKWgi-8yaSHDMlUj3Ga6LJoTlr-ipJnwYx3jXfpTwHs4dNKPV9fnDYRJxw~ob1BShyedge7E67qsGHZ6IuAQdUJwpKVYjhtvskfQTzn-fO~kJbwd5T4ggewiZC~qFYV0uQ~mkkW85-A9OayyTmo7K5liT0Whbf9SZZ-EO88LBlU-D0Xkulkce6eCfCXVZ74Yuzb8n9elE3Kwz~aabf6pq6etITn2VIiYvB71RDYGdtHIes8bFzLtpobph6PZ4nm~CVYc6MMCyyiOTAih5zpYFr~BFWaDI95jjZH~v8mTNWHQr0w__",
            createTimestamp: "2024-04-02T00:00:00Z",
            updateTimestamp: "2024-04-03T00:00:00Z",
            nickName: "快乐的小云朵"
        )
        self.userComments = [testComment]
        self.errorMessage = nil
    }

    func fetchUser() {
        isLoading = true
        guard let url = URL(string: "http://localhost:6000/api/therapist/comments?clinicianId=62c1d9988ab92b1ac4e7eabc") else {
            isLoading = false
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let comments = try decoder.decode([Comment].self, from: data)
                
                DispatchQueue.main.async {
                    self.userComments = comments
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
