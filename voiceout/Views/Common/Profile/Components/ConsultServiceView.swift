//
//  ConsultServiceView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct ConsultServiceView: View {
    var showEditButton: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            HStack(alignment: .top) {
                Text("咨询服务")
                    .font(Font.typography(.bodyLargeEmphasis))
                    .frame(alignment: .leading)
                    .foregroundColor(.textBrandPrimary)
                Spacer()
                if showEditButton {
                    EditButtonView(action: {
                    })
                }
            }
            
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("擅长人群：儿童、青少年、伴侣")
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textSecondary)
                    }
                    .frame(alignment: .topLeading)
                }
            }
            .frame(alignment: .topLeading)

            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                VStack(alignment: .leading) {
                    Text("咨询类型：亲子关系、心理创伤")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textSecondary)
                }
                .frame(alignment: .topLeading)
            }
            .frame(alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                VStack(alignment: .leading) {
                    Text("咨询风格：温柔、灵活、轻松")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textSecondary)
                }
                .frame(alignment: .topLeading)
            }
            .frame(alignment: .topLeading)
        }
        .padding(ViewSpacing.medium)
        .frame( alignment: .topLeading)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct ConsultServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultServiceView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

