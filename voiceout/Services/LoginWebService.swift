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

enum UserRole {
    case therapist
    case user
}

class LoginWebService {

    func login(email: String, password: String, role: UserRole, completions: @escaping (Result<String, AuthenticationError>) -> Void ) {
        let urlString = (role == .user) ? APIConfigs.userLogInURL : APIConfigs.therapistLogInURL
        guard let url = URL(string: urlString) else {
            return
        }

        let body = UserLogin(email: email, password: password)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completions(.failure(.na))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completions(.failure(.na))
                return
            }

                guard let data = data, error == nil else {
                    completions(.failure(.na))
                    return
                }

                if httpResponse.statusCode != 200 {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let errorMessages = errorResponse.errors.map {$0.msg}

                        for message in errorMessages {
                            if message.contains("用户不存在") {
                                completions(.failure(.userNotFound))
                                return
                            } else if message.contains("邮箱或密码错误") {
                                completions(.failure(.incorrectPasswordOrEmail))
                                return
                            }
                        }
                        completions(.failure(.na))
                    } else {
                        completions(.failure(.na))
                    }
                } else {
                    if let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data), let token = loginResponse.token {
                        UserDefaults.standard.set(token, forKey: "authToken")
                        completions(.success(token))
                    } else {
                        completions(.failure(.incorrectPasswordOrEmail))
                    }
                }
            }.resume()

        }

}
