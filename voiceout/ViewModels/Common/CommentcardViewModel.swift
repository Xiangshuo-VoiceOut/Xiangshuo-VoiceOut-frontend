//
//  CommentcardViewModel.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//

import Foundation

class CommentCardViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // test data
    func loadTestData() {
        let testComment=Comment(comment:"老师很温暖，气场温和，跟他聊天非常愉快!",rating:4)
        let testUser = User(
            _id: "1",
            nickname: "快乐的小云朵",
            profilePicture: ObjectId(id:"https://houseofroxylondon.com/cdn/shop/articles/Untitled_design-5_1296x.png?v=1675515844"),
            state: "NY, US",
            date: "2024-04-02",
            comments:[testComment]
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
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                guard let data = data, error == nil else {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = error.localizedDescription
                    print("Error decoding user: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
