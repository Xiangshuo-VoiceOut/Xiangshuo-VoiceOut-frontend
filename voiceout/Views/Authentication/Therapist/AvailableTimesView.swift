//
//  AvailableTimesView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/16/24.
//

import SwiftUI

struct AvailableTimesView: View {
    @EnvironmentObject var popupViewModel: PopupViewModel
    @EnvironmentObject var registrationVM: TherapistRegistrationVM
    @EnvironmentObject var timeInputVM: TimeInputViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: ViewSpacing.large) {
                Dropdown(
                    selectionOption: $registrationVM.selectedTimeZone,
                    label: "time_zone",
                    placeholder: "",
                    options: DropdownOption.timezones,
                    backgroundColor: .white,
                    isRequiredField: true
                )
                .onChange(of: registrationVM.selectedTimeZone) {
                    registrationVM.validateAvailableTimesComplete()
                }

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
                    OneWeekView(selectedDayIndices: $registrationVM.selectedDayIndices)
                        .onChange(of: registrationVM.selectedDayIndices) {
                            timeInputVM.updateTimeInputByDay(selectedDays: registrationVM.selectedDayIndices.sorted())
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

            Spacer()

            Text("flexible_availability_update")
                .frame(width: 206, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.typography(.bodyMedium))
                .foregroundColor(.textSecondary)
                .padding(.top, ViewSpacing.xlarge)
        }
        .onAppear {
            registrationVM.validateAvailableTimesComplete()
        }
    }
}

struct AvailableTimesView_Previews: PreviewProvider {
    static var previews: some View {
        let timeInputVM = TimeInputViewModel()
        let therapistRegistrationVM = TherapistRegistrationVM(textInputVM: TextInputVM(), timeInputVM: timeInputVM)

        AvailableTimesView()
            .environmentObject(PopupViewModel())
            .environmentObject(therapistRegistrationVM)
            .environmentObject(timeInputVM)
    }
}
