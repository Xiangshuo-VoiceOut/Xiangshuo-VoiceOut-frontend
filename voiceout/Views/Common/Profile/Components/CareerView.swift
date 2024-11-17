//
//  CareerView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct CareerView: View {
    var showEditButton: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            HStack(alignment: .top) {
                Text("从业经历")
                    .foregroundColor(.textBrandPrimary)
                    .font(Font.typography(.bodyLargeEmphasis))
                Spacer()
                if showEditButton {
                    EditButtonView(action: {
                    })
                }
            }
            .frame(height: 24, alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                HStack(alignment: .center) {
                    Text("NewYork-Presbyterian")
                        .foregroundColor(.textPrimary)
                        .font(Font.typography(.bodySmall))
                    Spacer()
                    Text("2023年6月至今")
                        .font(Font.typography(.bodyXSmallEmphasis))
                        .kerning(0.36)
                        .foregroundColor(.textSecondary)
                        .frame(height: 16, alignment: .topLeading)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                    Text("PSYCHIATRIC NURSE PRACTITIONER")
                        .foregroundColor(.textSecondary)
                        .font(Font.typography(.bodyXSmallEmphasis))
                        .kerning(0.36)
                }
                .frame(alignment: .topLeading)
            }
            .frame(alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                HStack(alignment: .top, spacing: ViewSpacing.medium) {
                    Text("北京大学学生心理健康教育与咨询中心实习生培养项目")
                        .foregroundColor(.textPrimary)
                        .font(Font.typography(.bodyXSmall))
                        .frame(alignment: .topLeading)
                    Spacer()
                    Text("2020年6月至2021年5月")
                        .foregroundColor(.textSecondary)
                        .font(Font.typography(.bodyXSmallEmphasis))
                        .kerning(0.36)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.leading, 0)
                .padding(.vertical, 0)
                .frame( alignment: .topLeading)
                
                HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                    Text("实习生")
                        .font(Font.typography(.bodyXSmallEmphasis))
                        .kerning(0.36)
                        .foregroundColor(.textSecondary)
                }
                .frame( alignment: .topLeading)
            }
            .frame(alignment: .topLeading)
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .frame(alignment: .topLeading)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct CareerView_Previews: PreviewProvider {
    static var previews: some View {
        CareerView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
