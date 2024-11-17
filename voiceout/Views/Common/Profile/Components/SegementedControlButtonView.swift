//  SegmentedButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/15/24.
//

import SwiftUI

struct SegmentedButtonView: View {
    @State private var selectedButton: Int = 0

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                selectedButton = 0
            }) {
                Text("基本信息")
                    .font(Font.typography(.bodyMediumEmphasis))
                    .foregroundColor(selectedButton == 0 ? .textPrimary : .textSecondary)
                    .padding(.horizontal,ViewSpacing.large)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(maxWidth: .infinity,alignment: .center)
                    .background(selectedButton == 0 ? Color.surfacePrimary : Color.surfacePrimaryGrey)
                    .clipShape(Capsule())
            }

            Button(action: {
                selectedButton = 1
            }) {
                Text("客户评价")
                    .font(Font.typography(.bodyMediumEmphasis))
                    .foregroundColor(selectedButton == 1 ? .textPrimary : .textSecondary)
                    .padding(.horizontal,ViewSpacing.large)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(maxWidth: .infinity,alignment: .center)
                    .background(selectedButton == 1 ? Color.surfacePrimary : Color.surfacePrimaryGrey)
                    .clipShape(Capsule())
            }

            Button(action: {
                selectedButton = 2
            }) {
                Text("咨询预约")
                    .font(Font.typography(.bodyMediumEmphasis))
                    .foregroundColor(selectedButton == 2 ? .textPrimary : .textSecondary)
                    .padding(.horizontal,ViewSpacing.large)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(maxWidth: .infinity,alignment: .center)
                    .background(selectedButton == 2 ? Color.surfacePrimary : Color.surfacePrimaryGrey)
                    .clipShape(Capsule())
            }
        }
        .padding(0)
        .frame(height: 37, alignment: .center)
        .background(Color.surfacePrimaryGrey)
        .cornerRadius(CornerRadius.large.value)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.large.value)
                .stroke(Color.surfacePrimaryGrey, lineWidth: 1)
        )
        .padding(.horizontal, ViewSpacing.medium)
    }
}

#Preview {
    SegmentedButtonView()
}
