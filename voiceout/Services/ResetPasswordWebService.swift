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

enum VerificationError: Error {
    case verificationCodeInvalid
    case na
}

struct ResetPasswordWebService {

    func requestPasswordReset(email: String, role: UserRole, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = (role == .user) ? APIConfigs.userForgetPWURL : APIConfigs.therapistForgetPWURL

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, _ in

            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            switch httpResponse.statusCode {
            case 200:
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                   let token = jsonResponse["token"] as? String {
                    UserDefaults.standard.set(token, forKey: "resetToken")
                    completion(.success(token))
                }
            case 404:
                completion(.failure(GetVerificationCodeError.userNotFound))
            default:
                completion(.failure(GetVerificationCodeError.na))
            }
        }.resume()
    }

    func validateResetToken(verificationCode: String, role: UserRole, completion: @escaping (Result<Bool, Error>) -> Void) {

        let urlString = (role == .user) ? APIConfigs.userValidateTokenURL : APIConfigs.therapistValidateTokenURL

        guard UserDefaults.standard.string(forKey: "resetToken") != nil else {
            completion(.failure(VerificationError.verificationCodeInvalid))
            return
        }

        guard let url = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = [
                "token": verificationCode
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, _ in

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(GetVerificationCodeError.na))
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

        let urlString = (role == .user) ? APIConfigs.userResetPWURL : APIConfigs.therapistResetPWURL

        guard let token = UserDefaults.standard.string(forKey: "resetToken"), !isTokenExpired() else {
            UserDefaults.standard.removeObject(forKey: "resetToken")
            UserDefaults.standard.removeObject(forKey: "resetTokenExpiry")
            completion(.failure(VerificationError.verificationCodeInvalid))
            return
        }

        guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["token": token, "password": newPassword]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { _, response, error in
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

    func isTokenExpired() -> Bool {
        guard let expiryDate = UserDefaults.standard.object(forKey: "resetTokenExpiry") as? Date else {
            return true
        }
        return Date() > expiryDate

    }
}
