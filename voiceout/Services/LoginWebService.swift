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
            if let error = error {
                completions(.failure(.na))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completions(.failure(.userNotFound))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completions(.failure(.userNotFound))
                    return
                }
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    if let token = loginResponse.token {
                        completions(.success(token))
                    } else {
                        completions(.failure(.userNotFound))
                    }
                } catch  {
                    completions(.failure(.userNotFound))
                }
            case 400...499:
                if let data = data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                   let firstError = errorResponse.errors.first {
                    if firstError.msg.contains("用户不存在") {
                        completions(.failure(.userNotFound))
                    } else {
                        completions(.failure(.incorrectPasswordOrEmail))
                    }
                } else {
                    completions(.failure(.incorrectPasswordOrEmail))
                }
            case 500...599:
                completions(.failure(.na))
            default:
                completions(.failure(.na))
            }
        }.resume()
        
        }
    }
