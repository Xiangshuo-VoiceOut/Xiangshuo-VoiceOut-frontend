//
//  LoginWebService.swift
//  voiceout
//
//  Created by J. Wu on 6/5/24.
//

import Foundation

enum AuthenticationError: Error {
    case userNotFound
    case incorrectPasswordOrEmail
    case na
}

struct LoginResponse: Codable {
    let token: String?
}

class LoginWebService {
    
    func login(email: String, password: String, completions: @escaping (Result<String, AuthenticationError>) -> Void ) {
        guard let url = URL(string: APIConfigs.LogInURL) else {
            return
        }
        
        let body = UserLogin(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode != 200 {
                if let errorResponse = try?  JSONDecoder().decode(ErrorResponse.self, from: data) {
                    let errorMessages = errorResponse.errors.map {$0.msg}
                    
                    for message in errorMessages {
                        if message.contains("用户不存在") {
                            completions(.failure(.userNotFound))
                            return
                        } else if message.contains("邮箱或密码错误"){
                            completions(.failure(.incorrectPasswordOrEmail))
                            return
                        }
                    }
                    completions(.failure(.na))
                } else {
                    completions(.failure(.na))
                }
            }else {
                    guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                          let token = loginResponse.token else {
                        completions(.failure(.na))
                        return
                    }
                    completions(.success(token))
                }
            }.resume()
        }
    }
