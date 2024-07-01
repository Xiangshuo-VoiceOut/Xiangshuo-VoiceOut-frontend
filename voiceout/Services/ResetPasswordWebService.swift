//
//  ResetPasswordWebService.swift
//  voiceout
//
//  Created by J. Wu on 6/5/24.
//

import Foundation

enum GetVerificationCodeError: Error {
    case userNotFound
    case na
}

enum VerificationError: Error{
    case verificationCodeInvalid
    case na
}


struct ResetPasswordWebService {
    
    func requestPasswordReset(email: String, role: UserRole, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = (role == .user) ? APIConfigs.userForgetPWURL : APIConfigs.therapistForgetPWURL
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                   let token = jsonResponse["token"] as? String {
                    UserDefaults.standard.set(token, forKey: "resetToken")
                    completion(.success(""))
                }
                completion(.success(""))
            case 404:
                completion(.failure(GetVerificationCodeError.userNotFound))
            default:
                completion(.failure(GetVerificationCodeError.na))
            }
        }.resume()
    }
    
    
    func validateResetToken(role: UserRole, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let urlString = (role == .user) ? APIConfigs.userForgetPWURL : APIConfigs.therapistForgetPWURL
        
        guard let token = UserDefaults.standard.string(forKey: "resetToken") else {
            completion(.failure(VerificationError.verificationCodeInvalid))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["token": token]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                completion(.success(true))
            case 400:
                completion(.failure(VerificationError.verificationCodeInvalid))
            default:
                completion(.failure(GetVerificationCodeError.na))
            }
        }.resume()
        }
    
    
    func resetPassword(newPassword: String, role: UserRole, completion: @escaping (Result<String, Error>) -> Void) {
        
        let urlString = (role == .user) ? APIConfigs.userForgetPWURL : APIConfigs.therapistForgetPWURL
        
        guard let token = UserDefaults.standard.string(forKey: "resetToken") else {
            completion(.failure(VerificationError.verificationCodeInvalid))
            return
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["token": token, "password": newPassword]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    UserDefaults.standard.removeObject(forKey: "resetToken")
                    completion(.success(""))
                case 400:
                    completion(.failure(VerificationError.verificationCodeInvalid))
                default:
                    completion(.failure(GetVerificationCodeError.na))
                }
            }.resume()
        }
}
