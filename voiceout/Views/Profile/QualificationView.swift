//
//  QualificationView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct QualificationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Edit Icon
            HStack {
                Text("资格证书")
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
            
            // First Qualification Entry
            HStack {
                Text("Psychiatrist, NY")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("2023年6月")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 12))
            }
            
            // Second Qualification Entry
            HStack {
                Text("国家二级心理咨询师")
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("2021年7月")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 12))
            }
        }
        .padding(16)
        .frame(width: 358, height: 120)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct QualificationView_Previews: PreviewProvider {
    static var previews: some View {
        QualificationView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
