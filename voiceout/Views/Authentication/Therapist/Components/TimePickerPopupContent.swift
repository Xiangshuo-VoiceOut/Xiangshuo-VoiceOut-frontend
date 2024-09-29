//
//  TimePickerPopupContent.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/23/24.
//

import SwiftUI

struct TimePickerPopupContent: View {
    @EnvironmentObject var popupViewModel: PopupViewModel
    @State private var activeTab: Tab = Tab.startEndTimes[0]
    @ObservedObject var timeInput: TimeInputData

    var body: some View {
        VStack(spacing: ViewSpacing.medium) {
            TabView(
                tabList: Tab.startEndTimes,
                panelList: [
                    AnyView(
                        TimePickerView(
                            hour: $timeInput.selectedStartTime,
                            amPm: $timeInput.selectedStartAmPm
                        )
                        .frame(width: 200)
                        .background(.white)
                        .cornerRadius(CornerRadius.small.value)
                    ),
                    AnyView(
                        TimePickerView(
                            hour: $timeInput.selectedEndTime,
                            amPm: $timeInput.selectedEndAmPm
                        )
                        .frame(width: 200)
                        .background(.white)
                        .cornerRadius(CornerRadius.small.value)
                    )
                ]
            )

            HStack(spacing: ViewSpacing.medium) {
                ButtonView(
                    text: "cancel",
                    action: {
                        dismissPopup()
                    },
                    variant: .outline
                )

                ButtonView(
                    text: "confirmation",
                    action: {
                        dismissPopup()
                    },
                    theme: .base,
                    spacing: .medium
                )
            }
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.large)
        .frame(maxWidth: .infinity)
    }

    private func dismissPopup() {
        withAnimation(.spring()) {
            popupViewModel.dismiss()
        }
    }
}

#Preview {
    TimePickerPopupContent(timeInput: TimeInputData())
        .environmentObject(PopupViewModel())
}
