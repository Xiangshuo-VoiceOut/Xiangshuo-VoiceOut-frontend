//
//  LoginWebService.swift
//  voiceout
//
//  Created by J. Wu on 6/5/24.
//

import Foundation
import Auth0

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

    func login(email: String, password: String, completions: @escaping (Result<String, AuthenticationError>) -> Void) {
        Auth0
            .authentication()
            .login(
                usernameOrEmail: email,
                password: password,
                realmOrConnection: "Username-Password-Authentication"
            )
            .start { result in
                switch result {
                    case .success(let credentials):
                        UserDefaults.standard.set(credentials.accessToken, forKey: "authToken")
                        completions(.success(credentials.accessToken))
                        
                    case .failure(let error):
                        if (error.code == "invalid_grant"){
                            completions(.failure(.incorrectPasswordOrEmail))
                        }else if (error.code == "user_not_found"){
                            completions(.failure(.userNotFound))
                        }
                        else {
                            completions(.failure(.na))
                        }
                }
            }
        }

        func logout() {
            Auth0
                .webAuth()
                .clearSession { result in
                    switch result {
                    case .success:
                        print("success")
                    case .failure(let error):
                        print("Failed with: \(error)")
                    }
                }
        }

}
