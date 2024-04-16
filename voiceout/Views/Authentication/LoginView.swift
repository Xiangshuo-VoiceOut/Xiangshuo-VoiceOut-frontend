//
//  LoginView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/19/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    init(){
        for family in UIFont.familyNames {
             print(family)

             for names in UIFont.fontNames(forFamilyName: family){
             print("== \(names)")
             }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                InputView(
                    text: $email,
                    icon: "email",
                    placeholder: "email_placeholder"
                )
                .autocapitalization(.none)
                
                InputView(
                    text: $password,
                    icon: "lock",
                    placeholder: "password_placeholder"
                )
                .autocapitalization(.none)
                
                Text("123")
                    .font(.custom("AlibabaPuHuiTi_3_65_Medium", size: 23))
            }
            .background(Color(.backgroundLight))
            .padding(EdgeInsets(top: 36, leading: 34, bottom: 26, trailing: 34))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
