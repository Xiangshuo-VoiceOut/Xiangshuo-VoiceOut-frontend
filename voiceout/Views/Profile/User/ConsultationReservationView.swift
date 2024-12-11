//
//  ConsultationReservationView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/23/24.
//

import SwiftUI

struct ConsultationReservationView: View {
    @StateObject var viewModel = TherapistScheduleViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: ViewSpacing.medium) {
                TherapistScheduleCalendarView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, alignment: .top)

                if viewModel.selectedDate != nil { 
                    TherapistScheduleTimeView(viewModel: viewModel, selectedDate: viewModel.selectedDate!)
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                Image("separator")
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.surfacePrimaryGrey, lineWidth: 1)
                    )
                    .padding(.bottom, ViewSpacing.small)

                VStack(alignment: .center, spacing: ViewSpacing.medium) {
                    Text("预约须知")
                        .font(Font.typography(.bodyLargeEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textTitle)

                    Text("""
                    1. 若咨询师未在24小时内确认预约，算订单作废，您会收到全额退款。

                    2. 在咨询师确认之前您可以自主取消订单。若需要修改时间，请提前至少24小时私信咨询师商议，否则将按原定时间开始。

                    3. 当咨询师接受您的预约后，您会通过私信收到视频咨询的链接。

                    4. 若您未按时进入视频通话，咨询仍会在规定时间内结束并正常收取费用。
                    5. 建议您预约前详读咨询
                    """)
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                     + Text("FAQ")
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textBrandSecondary)

                    NavigationLink(destination: WaitingConfirmationView()) {
                        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase
                        ) {
                            Text("立即预约")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(viewModel.isAppointmentReady ? .textInvert : .textPrimary)
                        }
                        .padding(.horizontal, ViewSpacing.xxxxlarge)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(alignment: .center)
                        .background(viewModel.isAppointmentReady ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
                        .cornerRadius(CornerRadius.full.value)
                    }
                    .disabled(!viewModel.isAppointmentReady)
                }
                .padding(.horizontal, ViewSpacing.large)
            }
        }
        .background(Color.surfacePrimaryGrey2)
        .onAppear {
            viewModel.fetchAvailabilities()
        }
    }
}

#Preview {
    ConsultationReservationView()
}
