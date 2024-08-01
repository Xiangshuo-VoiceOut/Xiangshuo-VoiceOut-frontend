//
//  TherapistScheduleTimeView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//
import SwiftUI

struct TherapistScheduleTimeView: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel
    @State private var selectedTimeSlot: Slot?
    var selectedDate: Date

    var body: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            headerView
            timeSlotsView
        }
        .padding(ViewSpacing.medium)
        .cornerRadius(CornerRadius.medium.value)
        .frame(width: 340, height: 235, alignment: .center)
        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
        .onAppear {
            viewModel.selectDate(selectedDate)
        }
    }

    private var headerView: some View {
        //Calendar
        VStack(alignment: .center, spacing: 0) {
            //Caption
            HStack(alignment: .center, spacing: 0) {
                //Month
                HStack(alignment: .top, spacing: ViewSpacing.small){
                    Text(viewModel.selectedMonthFormatted)
                        .font(Font.typography(.bodyLarge))
                        .foregroundColor(.grey900)
                }
                .frame(width:52,height:33)
                .padding(.horizontal, ViewSpacing.small)
                .padding(.vertical, ViewSpacing.xsmall)
                //Year
                HStack(alignment: .top, spacing: ViewSpacing.small){
                    Text(viewModel.selectedDayFormatted)
                        .font(Font.typography(.bodyLargeEmphasis))
                        .foregroundColor(.grey900)
                }
                .frame(width:39,height:33)
                .padding(.horizontal, 0)
                .padding(.vertical, ViewSpacing.xsmall)
            }
            .frame(height: 33, alignment: .center)
            .padding(0)
            .cornerRadius(CornerRadius.xxxsmall.value)
        }
        .padding(0)
        .cornerRadius(CornerRadius.medium.value)
    }

    private var timeSlotsView: some View {
        //40
        VStack(alignment: .center, spacing: ViewSpacing.small) {
            ForEach(0..<3, id: \.self) { rowIndex in
                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        if index < viewModel.timeSlots.count {
                            timeSlotButton(for: viewModel.timeSlots[index])
                        } else {
                            timeSlotButton(for: Slot(id: UUID(), startTime: Date(), endTime: Date(), isAvailable: false))
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, ViewSpacing.xsmall)
                .frame(width: 308, alignment: .center)
                .cornerRadius(CornerRadius.xxxsmall.value)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, ViewSpacing.xsmall)
        .frame(width: 308, alignment: .center)
        .cornerRadius(CornerRadius.xxxsmall.value)
    }

    private func timeSlotButton(for slot: Slot) -> some View {
        Button(action: {
            if slot.isAvailable {
                selectedTimeSlot = slot
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: CornerRadius.small.value)
                    .fill(selectedTimeSlot == slot ? Color("brand-primary") : .grey75)
                    .frame(width: 90, height: 38)
                Text(viewModel.formatTime(slot.startTime))
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(selectedTimeSlot == slot ? .textInvert : slot.isAvailable ? .grey500 : Color("grey-60"))
                
            }
        }
        .disabled(!slot.isAvailable)
        .animation(.default, value: selectedTimeSlot)
    }
}

#Preview {
    TherapistScheduleTimeView(viewModel: TherapistScheduleViewModel(), selectedDate: Date())
}
