//
//  Personal.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct PersonalView: View {
    var age: String
    var gender: String
    var location: String
    var language: String
    var showEditButton: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            HStack(alignment: .center, spacing: ViewSpacing.xxlarge) {
                HStack(alignment: .top, spacing: ViewSpacing.xlarge) {
                    HStack(alignment: .center, spacing: ViewSpacing.small){
                        Text("年龄")
                            .foregroundColor(.textPrimary)
                            .font(Font.typography(.bodyMedium))
                        Text(age)
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodySmall))
                    }
                    HStack(alignment: .center, spacing: ViewSpacing.xsmall) {
                        Text("性别")
                            .foregroundColor(.textPrimary)
                            .font(Font.typography(.bodyMedium))
                        Text(gender)
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodySmall))
                    }
                    HStack(alignment: .center, spacing: ViewSpacing.xsmall) {
                        Text("地区")
                            .foregroundColor(.textPrimary)
                            .font(Font.typography(.bodyMedium))
                        Text(location)
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodySmall))
                    }
                    Spacer()
                    if showEditButton {
                        EditButtonView(action: {
                        })
                    }
                }
                .padding(.leading, 0)
                .padding(.trailing, ViewSpacing.small)
                .padding(.vertical, ViewSpacing.xxxsmall)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack (alignment: .center, spacing: ViewSpacing.xxlarge){
                HStack(alignment: .top, spacing: ViewSpacing.small) {
                    Text("咨询语言")
                        .foregroundColor(.textPrimary)
                        .font(Font.typography(.bodyMedium))
                    Text(language)
                        .foregroundColor(.textSecondary)
                        .font(Font.typography(.bodySmall))
                }
            }
            .frame(alignment: .leading)
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .frame(maxWidth: .infinity, alignment: .topLeading)
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
    }
}
