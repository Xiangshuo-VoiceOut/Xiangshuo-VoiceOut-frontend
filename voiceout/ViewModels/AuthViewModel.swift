//
//  AuthViewModel.swift
//  voiceout
//
//  Created by J. Wu on 5/25/24.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(){
        guard let url = URL(string:APIConfigs.LogInURL) else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String:Any] = ["email":email, "password":password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Login request failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.message == "" { //to be checked
                    self.isAuthenticated = true
                }
            })
            .store(in: &cancellables)
    }
}


