//
//  CareerView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct CareerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Edit Icon
            HStack {
                Text("从业经历")
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
            
            // First Career Entry
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("NewYork-Presbyterian")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text("2023年6月至今")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                }
                
                HStack {
                    Text("PSYCHIATRIC NURSE PRACTITIONER")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 12))
                    Text("|")
                        .foregroundColor(.textSecondary)
                    Text("PMHNP")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 12))
                }
            }
            
            // Second Career Entry
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("北京大学学生心理健康教育与咨询中心实习生培养项目")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text("2020年6月至2021年5月")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                }
                
                HStack {
                    Text("实习生")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct CareerView_Previews: PreviewProvider {
    static var previews: some View {
        CareerView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
