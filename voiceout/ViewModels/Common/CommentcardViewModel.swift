//
//  CommentcardViewModel.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//

import Foundation

class CommentCardViewModel: ObservableObject {
    @Published var user: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadTestData() {
        let testComment=Comment(comment: "老师很温暖，气场温和，跟他聊天非常愉快!")
        let testUser = UserProfile(
            _id: "1",
            nickname: "快乐的小云朵",
            profilePicture: ObjectId(id: "https://s3-alpha-sig.figma.com/img/cc95/6287/bb02dcd901a19d4857fdc3ed4d9ae631?Expires=1733097600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OQ2oS~AjsCNhOuhXQ-Ft4F1F~OHuvzqRY8r5C7lPKWgi-8yaSHDMlUj3Ga6LJoTlr-ipJnwYx3jXfpTwHs4dNKPV9fnDYRJxw~ob1BShyedge7E67qsGHZ6IuAQdUJwpKVYjhtvskfQTzn-fO~kJbwd5T4ggewiZC~qFYV0uQ~mkkW85-A9OayyTmo7K5liT0Whbf9SZZ-EO88LBlU-D0Xkulkce6eCfCXVZ74Yuzb8n9elE3Kwz~aabf6pq6etITn2VIiYvB71RDYGdtHIes8bFzLtpobph6PZ4nm~CVYc6MMCyyiOTAih5zpYFr~BFWaDI95jjZH~v8mTNWHQr0w__"),
            state: "NY, US",
            date: "2024年4月2日",
            comments: [testComment]
        )
        self.user = testUser
        self.errorMessage = nil
    }

    func fetchUser() {
            isLoading = true
            guard let url = URL(string: "http://localhost:5000/api/profile/me") else {
                isLoading = false
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }

                guard let data = data, error == nil else {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }

                do {
                    let user = try JSONDecoder().decode(UserProfile.self, from: data)
                    self.user = user
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = error.localizedDescription
                    print("Error decoding user: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
