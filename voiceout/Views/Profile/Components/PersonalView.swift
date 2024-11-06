//
//  Personal.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

//  TODO: 1. Edit feature - pencil button action and variable passing
struct PersonalView: View {
    var age: String
    var gender: String
    var location: String
    var language: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Text("年龄")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 16))
                    Text(age)
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 14))
                }
                HStack(spacing: 6) {
                    Text("性别")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 16))
                    Text(gender)
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 14))
                }
                HStack(spacing: 6) {
                    Text("地区")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 16))
                    Text(location)
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 14))
                }
                Spacer()
                
                Button(action: {
                    // placeholder for edit page
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.borderLight)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 24)
            
            HStack {
                Text("咨询语言")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 16))
                Text(language)
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 22)
        }
        .padding(16)
        .frame(width: 358, height: 86)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView(
            age: "32",
            gender: "女",
            location: "NY",
            language: "普通话"
        )
    }
}
