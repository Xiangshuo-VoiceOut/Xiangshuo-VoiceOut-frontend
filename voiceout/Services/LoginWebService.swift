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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completions(.failure(.na))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completions(.failure(.na))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completions(.failure(.na))
                    return
                }
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    if let token = loginResponse.token {
                        completions(.success(token))
                    } else {
                        completions(.failure(.na))
                    }
                } catch  {
                    completions(.failure(.na))
                }
            case 400...499:
                completions(.failure(.incorrectPasswordOrEmail))
            case 500...599:
                completions(.failure(.na))
            default:
                completions(.failure(.na))
            }
        }.resume()
        
        }
    }
