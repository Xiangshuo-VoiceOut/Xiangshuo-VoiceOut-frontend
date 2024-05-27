//
//  ResetPWViewModel.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import Foundation
import Combine

class ResetPWViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var verificationCode: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    @Published var isVerificationCodeSent: Bool = false
    @Published var isPasswordReset: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func sendVerificationCode() {
        guard let url = URL(string:APIConfigs.forgetPWURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fialed to send verification code.")
                    break
                case.finished:
                    break
                }
            }, receiveValue: { response in
                if response.message == "重置密码邮件已发送." {
                    self.isVerificationCodeSent = true
                } else {
                    print(response.message)
                }
                
            })
            .store(in: &cancellables)
    }
    
   
    
    func resetPassword() {
        guard let url = URL(string:APIConfigs.resetPWURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "token": verificationCode,
            "newPassword": newPassword,
            "confirmNewPassword": confirmNewPassword
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map{$0.data}
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to reset password")
                case.finished:
                    break
                }
            }, receiveValue: { response in
                if response.message == "密码已重置成功" {
                    self.isPasswordReset = true
                } else {
                    print(response.message)
                }
            })
            .store(in: &cancellables)
    }
}
