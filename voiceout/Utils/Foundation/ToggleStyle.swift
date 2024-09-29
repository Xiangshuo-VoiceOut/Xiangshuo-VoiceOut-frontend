//
//  ToggleStyle.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/16/24.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)

            Spacer()

            RoundedRectangle(
                cornerRadius: 360,
                style: .circular
            )
            .fill(configuration.isOn ? Color.brandPrimary : Color.surfacePrimaryGrey)
            .frame(width: 52, height: 26)
            .overlay(
                Circle()
                    .fill(.white)
                    .padding(ViewSpacing.xxsmall)
                    .frame(width: 24, height: 24)
                    .offset(x: configuration.isOn ? 12 : -12)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
