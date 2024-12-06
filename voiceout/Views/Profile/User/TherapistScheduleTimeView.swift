//
//  TherapistScheduleTimeView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI

struct TherapistScheduleTimeView: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel
    var selectedDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            headerView
            timeSlotsView
        }
        .padding(ViewSpacing.medium)
        .frame(alignment: .topLeading)
        .background(Color.surfacePrimary)
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 8)
        .onAppear {
            viewModel.timeSlots = generateFixedTimeSlots(for: selectedDate)
        }
        .cornerRadius(CornerRadius.medium.value)

    }

    private var headerView: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 0) {
                Text(selectedDate.formatFullDate)
                    .font(Font.typography(.bodyLargeEmphasis))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(0)
        .cornerRadius(CornerRadius.medium.value)
    }

    private var timeSlotsView: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            ForEach(0..<3, id: \.self) { rowIndex in
                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        if index < viewModel.timeSlots.count {
                            timeSlotButton(for: viewModel.timeSlots[index])
                        } else {
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, ViewSpacing.small)
                .frame(alignment: .center)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, ViewSpacing.xsmall)
        .frame(alignment: .center)
    }

    private func timeSlotButton(for slot: Slot) -> some View {
        Button(action: {
            if slot.isAvailable {
                viewModel.selectTimeSlot(slot)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.small.value)
                    .fill(viewModel.selectedTimeSlot == slot ? Color.surfaceBrandPrimary : .grey75)
                    .frame(height: 38)

                Text(slot.startTime.formatTime)
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(
                        viewModel.selectedTimeSlot == slot ? .textInvert : slot.isAvailable ? .textPrimary : .textLight
                    )
            }
        }
        .disabled(!slot.isAvailable)
        .animation(.default, value: viewModel.selectedTimeSlot)
    }

    private func generateFixedTimeSlots(for date: Date) -> [Slot] {
        let calendar = Calendar.current
        let startHour = 10
        let endHour = 19
        let interval = 1

        return (startHour..<endHour).map { hour in
            let startTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date)!
            let endTime = calendar.date(byAdding: .hour, value: interval, to: startTime)!
            return Slot(id: UUID(), startTime: startTime, endTime: endTime, isAvailable: true)
        }
    }
}

#Preview {
    TherapistScheduleTimeView(viewModel: TherapistScheduleViewModel(), selectedDate: Date())
}
