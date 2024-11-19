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
        TherapistProfilePageCardView(title: "资格证书", showEditButton: showEditButton) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                VStack(alignment: .leading) {
                    Text("Psychiatrist, NY")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                }
                VStack(alignment: .leading) {
                    Text("国家二级心理咨询师, CN")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

struct QualificationView_Previews: PreviewProvider {
    static var previews: some View {
        QualificationView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
