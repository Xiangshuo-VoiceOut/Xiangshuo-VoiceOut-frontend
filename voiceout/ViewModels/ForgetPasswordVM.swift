//
//  ForgetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation
import Combine

class ForgetPWViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var isEmailValid: Bool = true
    @Published var verificationCode: String = ""
    @Published var isVarificationCodeValid: Bool = true
    @Published var isVerificationCodeSent: Bool = false
    @Published var timerValue: Int = 300
    @Published var isNextButtonEnabled: Bool = false
    @Published var emailValidationMessage: String = ""
    @Published var verficationCodeValidationMsg: String = ""
    
    
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var verificationToken: String? = nil
    
    func sendVerificationCode() {
        if !validateEmail() {
            return
        }
        
        guard let url = URL(string: APIConfigs.forgetPWURL) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            guard let data = data, error == nil else {return}
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.isVerificationCodeSent = true
                        self.startTimer()
                    } else {
                        self.handleValidationErrors(data: data)
                    }
                }
            }
            
        }.resume()
    }
    
    private func startTimer() {
        self.timerValue = 300
        self.timer?.cancel()
        
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink {[weak self] _ in
            guard let self = self else {return}
            if self.timerValue > 0 {
                self.timerValue -= 1
            } else {
                self.timer?.cancel()
                self.isVerificationCodeSent = false
            }
            
        }
    }
    
    
    //TODO
    private func isVerificationValid(){
        if validateEmail() {
            return
        }
        
        //TODO
    }
    
    private func handleValidationErrors(data: Data) {
        let decoder = JSONDecoder()
        if let responseDict = try? decoder.decode([String:[String]].self, from: data){
            if let errors = responseDict["errors"] {
                for error in errors {
                    if error.contains("邮箱格式不正确") {
                        self.emailValidationMessage = "email_form_error"
                    } else if error.contains("邮箱不存在") {
                        self.emailValidationMessage = "email_not_exist"
                    } else if error.contains("验证码错误") {
                        self.verficationCodeValidationMsg = "verification_wrong"
                    }
                }
            }
        } else {
            print("Invalid response data")
        }
    }
    func resetValidateState(){
        isEmailValid = true
        isVarificationCodeValid = true
        emailValidationMessage = ""
        verficationCodeValidationMsg = ""
    }
    
    func validateEmail() -> Bool {
        if !isValidEmail(email) {
            isEmailValid = false
            emailValidationMessage = "email_form_error"
            return false
        } else {
            isEmailValid = true
            emailValidationMessage = ""
            return true
        }
        
    }
    
    func validateInputs(){
        isNextButtonEnabled = !email.isEmpty && !verificationCode.isEmpty
    }
    
    
}
