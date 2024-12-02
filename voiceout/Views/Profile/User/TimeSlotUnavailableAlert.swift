//
//  TimeSlotUnavailableAlert.swift
//  voiceout
//
//  Created by Yujia Yang on 11/25/24.
//

import SwiftUI

struct TimeSlotUnavailableAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 2)

            VStack(alignment: .center, spacing: ViewSpacing.large) {
                VStack(alignment: .center, spacing: ViewSpacing.small) {
                    VStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                        Text("这个时间段已经被预定了，请选择其他时间段。")
                            .font(Font.typography(.bodyLargeEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)
                            .frame(alignment: .top)
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .cornerRadius(CornerRadius.medium.value)
                }
                .frame(maxWidth: .infinity, alignment: .top)

                VStack(alignment: .center, spacing: ViewSpacing.small) {
                    VStack(alignment: .center, spacing: ViewSpacing.medium) {
                        Button(action: {
                            print("Acknowledged")
                        }) {
                            Text("我知道了")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textInvert)
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .padding(.horizontal, ViewSpacing.large)
                        .background(Color.surfaceBrandPrimary)
                        .cornerRadius(CornerRadius.full.value)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .padding(ViewSpacing.medium)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
            .frame(width: 270, height: 190, alignment: .top)
        }
    }
}

#Preview {
    TimeSlotUnavailableAlert()
}
