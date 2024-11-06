//
//  ConsultServiceView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct ConsultServiceView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and Edit Icon
            HStack {
                Text("咨询服务")
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
            
            // First Content Entry
            HStack(alignment: .top) {
                Text("擅长人群：")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Text("儿童、青少年、伴侣")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Spacer()
            }
            
            // Second Content Entry
            HStack(alignment: .top) {
                Text("咨询类型：")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Text("亲子关系、心理创伤")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Spacer()
            }
            
            // Third Content Entry
            HStack(alignment: .top) {
                Text("咨询风格：")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Text("温柔、灵活、轻松")
                    .foregroundColor(.textSecondary)
                    .font(.system(size: 14))
                Spacer()
            }
        }
        .padding(16)
        .frame(width: 358, height: 164)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct ConsultServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultServiceView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

