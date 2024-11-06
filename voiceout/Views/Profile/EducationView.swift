//
//  EducationView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct EducationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Edit Icon
            HStack {
                Text("学历")
                    .foregroundColor(.textBrandPrimary)
                    .font(.system(size: 18, weight: .bold))
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
            
            // First Education Entry
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("哥伦比亚大学")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text("2021年9月至2023年5月")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 12))
                }
                
                HStack {
                    Text("硕士")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                    Text("|")
                        .foregroundColor(.textSecondary)
                    Text("心理学")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                }
            }
            
            // Second Education Entry
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("纽约大学")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text("2017年9月至2021年5月")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 12))
                }
                
                HStack {
                    Text("学士")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                    Text("|")
                        .foregroundColor(.textSecondary)
                    Text("心理学")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(16)
        .frame(width: 358, height: 160)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct EducationView_Previews: PreviewProvider {
    static var previews: some View {
        EducationView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

