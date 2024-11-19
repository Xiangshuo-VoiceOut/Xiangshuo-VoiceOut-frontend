//
//  SignUpWebService.swift
//  voiceout
//
//  Created by J. Wu on 7/16/24.
//

import Foundation

enum SignUpError: Error {
    case userExists
    case verificationCodeError
    case nicknameExists
    case na
}

class UserSignUpWebService {
    func userSignUp(email: String, password: String, otp: String, nickname: String, state: String, birthdate: String, gender: String, completions: @escaping (Result<String, SignUpError>) -> Void ) {
        let urlString = APIConfigs.userSignUpURL
        guard let url = URL(string: urlString) else {

            return
        }

        let body = UserSignUp(email: email, password: password, otp: otp, nickname: nickname, state: state, birthdate: birthdate, gender: gender)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completions(.failure(.na))
                return
            }

            guard response is HTTPURLResponse else {
                return
            }

            URLSession.shared.dataTask(with: request) {(data, response, error) in

                guard let data = data, error == nil else {
                    return
                }

                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode != 200 {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        let errorMessages = errorResponse.errors.map {$0.msg}

                        for message in errorMessages {
                            if message.contains("重新获取验证码") {
                                completions(.failure(.verificationCodeError))
                                return
                            } else if message.contains("该邮箱已被注册") {
                                completions(.failure(.userExists))
                                return
                            } else if message.contains("该昵称已有用户注册") {
                                completions(.failure(.nicknameExists))
                            }
                        }
                        completions(.failure(.na))
                    }
                } else {
                    guard let loginResponse = try? JSONDecoder().decode(SignUpResponse.self, from: data), let token = loginResponse.token else {
                        completions(.failure(.na))
                        return
                    }
                    completions(.success(token))
                }
            }.resume()

        }
    }
}
