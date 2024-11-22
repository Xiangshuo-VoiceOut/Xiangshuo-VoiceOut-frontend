//
//  QualificationView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import SwiftUI

struct QualificationView: View {
    var showEditButton: Bool
    var qualifications: [String]

    var body: some View {
        ProfileCardView(
            title: LocalizedStringKey("certificate_info"),
            showEditButton: showEditButton
        ) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                ForEach(qualifications, id: \.self) { qualification in
                    Text(qualification)
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

struct QualificationView_Previews: PreviewProvider {
    static var previews: some View {
        QualificationView(
            showEditButton: true,
            qualifications: [
                "Psychiatrist, NY",
                "国家二级心理咨询师, CN"
            ]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
