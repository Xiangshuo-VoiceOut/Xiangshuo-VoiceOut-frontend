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
    private var initSelectedStartTime: Int
    private var initSelectedStartAMPM: String
    private var initSelectedEndTime: Int
    private var initSelectedEndAMPM: String

    init(timeInput: TimeInputData) {
        self.timeInput = timeInput
        initSelectedStartTime = timeInput.selectedStartTime
        initSelectedStartAMPM = timeInput.selectedStartAmPm
        initSelectedEndTime = timeInput.selectedEndTime
        initSelectedEndAMPM = timeInput.selectedEndAmPm
    }

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
                        cancelSelection()
                    },
                    variant: .outline
                )

                ButtonView(
                    text: "confirmation",
                    action: {
                        dismissPopup()
                    },
                    theme: .action,
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

    private func cancelSelection() {
        timeInput.selectedStartTime = initSelectedStartTime
        timeInput.selectedStartAmPm = initSelectedStartAMPM
        timeInput.selectedEndTime = initSelectedEndTime
        timeInput.selectedEndAmPm = initSelectedEndAMPM
    }
}

#Preview {
    TimePickerPopupContent(timeInput: TimeInputData())
        .environmentObject(PopupViewModel())
}
