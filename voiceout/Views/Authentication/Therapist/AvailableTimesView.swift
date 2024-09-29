//
//  AvailableTimesView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/16/24.
//

import SwiftUI

struct AvailableTimesView: View {
    @EnvironmentObject var popupViewModel: PopupViewModel
    @StateObject private var registrationVM: TherapistRegistrationVM
    @StateObject private var timeInputVM: TimeInputViewModel
    @State var selectedDayIndices: Set<Int> = [0, 1, 2, 3, 4, 5, 6]

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
        _timeInputVM = StateObject(wrappedValue: TimeInputViewModel())
    }

    var body: some View {
        ZStack {
            Color
                .clear
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: ViewSpacing.large) {
                Dropdown(
                    selectionOption: $registrationVM.selectedTimeZone,
                    label: "time_zone",
                    placeholder: "",
                    options: DropdownOption.timezones,
                    backgroundColor: .white
                )

                Toggle(
                    "schedule_same_time",
                    isOn: $registrationVM.isSameTimeSchedule
                )
                .toggleStyle(CustomToggleStyle())

                if registrationVM.isSameTimeSchedule {
                    ForEach(Array(timeInputVM.timeInputs.enumerated()), id: \.offset) { index, timeInputData in
                        TimeInputView(
                            label: "time",
                            addAction: {
                                timeInputVM.addTimeInput()
                            },
                            removeAction: {
                                timeInputVM.removeTimeInput(at: index)
                            },
                            showRemoveButton: timeInputVM.timeInputs.count > 1 && index != 0,
                            timeInput: timeInputData
                        )
                    }
                } else {
                    OneWeekView(selectedDayIndices: $selectedDayIndices)
                        .onChange(of: selectedDayIndices) {
                            timeInputVM.updateTimeInputByDay(selectedDays: selectedDayIndices.sorted())
                        }

                    ForEach(Array(timeInputVM.timeInputsByWeek.enumerated()), id: \.offset) {index, timeInputsPerDay in
                        ForEach(Array(timeInputsPerDay.enumerated()), id: \.offset) { i, timeInputData in
                            if let timeInputData = timeInputData {
                                TimeInputView(
                                    label: i == 0 ? Day.weekLabel[index].label : "",
                                    addAction: {
                                        timeInputVM.addTimeInputByDay(at: index)
                                    },
                                    removeAction: {
                                        timeInputVM.removeTimeInputByDay(at: index, index: i)
                                    },
                                    showRemoveButton: timeInputsPerDay.count > 1 && i != 0,
                                    timeInput: timeInputData
                                )
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .popup(with: .popupViewModel(popupViewModel))
    }
}

#Preview {
    AvailableTimesView()
        .environmentObject(PopupViewModel())
}
