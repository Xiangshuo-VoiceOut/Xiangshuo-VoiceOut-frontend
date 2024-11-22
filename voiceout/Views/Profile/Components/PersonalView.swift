//
//  PersonalView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import SwiftUI

struct PersonalView: View {
    var age: String
    var gender: String
    var location: String
    var language: String
    var showEditButton: Bool

    var body: some View {
        TherapistProfilePageCardView(title: nil, showEditButton: false) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                HStack(alignment: .center, spacing: ViewSpacing.xxlarge) {
                    HStack(alignment: .top, spacing: ViewSpacing.xlarge) {
                        InfoPair(label: LocalizedStringKey("age"), value: age)
                        InfoPair(label: LocalizedStringKey("gender"), value: gender)
                        InfoPair(label: LocalizedStringKey("location"), value: location)

                        Spacer()

                        if showEditButton {
                            EditButtonView(action: {
                                print("Edit button tapped")
                            })
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .center, spacing: ViewSpacing.xxlarge) {
                    InfoPair(label: LocalizedStringKey("language"), value: language)
                }
                .frame(alignment: .leading)
            }
        }
    }
}

struct InfoPair: View {
    let label: LocalizedStringKey
    let value: String

    var body: some View {
        HStack(alignment: .center, spacing: ViewSpacing.xsmall) {
            Text(label)
                .foregroundColor(.textPrimary)
                .font(Font.typography(.bodyMedium))
            Text(value)
                .foregroundColor(.textSecondary)
                .font(Font.typography(.bodySmall))
        }
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView(
            age: "32",
            gender: "女",
            location: "NY",
            language: "普通话，西班牙语",
            showEditButton: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
