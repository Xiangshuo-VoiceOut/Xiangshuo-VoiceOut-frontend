//
//  QualificationView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct QualificationView: View {
    var showEditButton: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            HStack(alignment: .top) {
                Text("资格证书")
                    .foregroundColor(.textBrandPrimary)
                    .font(Font.typography(.bodyLargeEmphasis))
                    .frame(alignment: .leading)
                Spacer()
                if showEditButton {
                    EditButtonView(action: {
                    })
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                VStack(alignment: .leading) {
                    Text("Psychiatrist, NY")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                        .frame(alignment: .leading)
                }
                .frame(alignment: .topLeading)
                VStack(alignment: .leading) {
                    Text("国家二级心理咨询师, CN")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                }
                .frame(alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(ViewSpacing.medium)
        .frame(alignment: .topLeading)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct QualificationView_Previews: PreviewProvider {
    static var previews: some View {
        QualificationView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
