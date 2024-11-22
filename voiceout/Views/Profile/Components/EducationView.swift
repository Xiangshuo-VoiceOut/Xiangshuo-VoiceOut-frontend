//
//  EducationView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct EducationView: View {
    var showEditButton: Bool

    var body: some View {
        TherapistProfilePageCardView(title: LocalizedStringKey("degree"), showEditButton: showEditButton) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                    HStack(alignment: .center) {
                        Text("哥伦比亚大学")
                            .foregroundColor(.textPrimary)
                            .font(Font.typography(.bodySmall))
                        Spacer()
                        Text("2021年9月至2023年5月")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                            .kerning(0.36)
                    }

                    HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                        Text("硕士")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                        Text("|")
                            .foregroundColor(.textSecondary)
                        Text("心理学")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                    }
                }

                VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                    HStack(alignment: .center) {
                        Text("纽约大学")
                            .foregroundColor(.textPrimary)
                            .font(Font.typography(.bodySmall))
                        Spacer()
                        Text("2017年9月至2021年5月")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                            .kerning(0.36)
                    }

                    HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                        Text("学士")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                        Text("|")
                            .foregroundColor(.textSecondary)
                        Text("心理学")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyXSmallEmphasis))
                    }
                }
            }
        }
    }
}

struct EducationView_Previews: PreviewProvider {
    static var previews: some View {
        EducationView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
