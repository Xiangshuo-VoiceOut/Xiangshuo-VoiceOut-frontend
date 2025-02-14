//
//  TherapistScheduleTimeView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI

struct TherapistScheduleTimeView: View {
    @ObservedObject var viewModel: TherapistProfilePageService
    @Binding var selectedTimeSlot: Slot?
    
    var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            headerView
            timeSlotsView
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 8)
        .onAppear {
            viewModel.fetchTimeSlots(for: selectedDate)
        }
    }
    
    private var headerView: some View {
        Text(formatFullDate(selectedDate))
            .font(Font.typography(.bodyLargeEmphasis))
            .multilineTextAlignment(.center)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity)
    }
    
    private var timeSlotsView: some View {
        GeometryReader { geometry in
            let slotsPerRow = 3
            let spacing: CGFloat = ViewSpacing.medium
            let totalPadding: CGFloat = ViewSpacing.xlarge
            let availableWidth = geometry.size.width - totalPadding - CGFloat(slotsPerRow - 1) * spacing
            let slotWidth = availableWidth / CGFloat(slotsPerRow)
            
            VStack(alignment: .center, spacing: spacing) {
                let rowCount = (viewModel.timeSlots.count + slotsPerRow - 1) / slotsPerRow
                
                ForEach(0..<rowCount, id: \.self) { rowIndex in
                    HStack(alignment: .center, spacing: spacing) {
                        ForEach(0..<slotsPerRow, id: \.self) { columnIndex in
                            let index = rowIndex * slotsPerRow + columnIndex
                            if index < viewModel.timeSlots.count {
                                timeSlotButton(for: viewModel.timeSlots[index])
                                    .frame(width: slotWidth, height: 38)
                            } else {
                                Spacer()
                                    .frame(width: slotWidth, height: 38)
                            }
                        }
                    }
                }
            }
        }
        .frame(height: calculateViewHeight())
    }
    
    private func calculateViewHeight() -> CGFloat {
        let slotsPerRow = 3
        let rowCount = (viewModel.timeSlots.count + slotsPerRow - 1) / slotsPerRow
        let slotHeight: CGFloat = 38
        let spacing: CGFloat = ViewSpacing.medium
        return CGFloat(rowCount) * (slotHeight + spacing) - spacing    }
    
    private func timeSlotButton(for slot: Slot) -> some View {
        Button(action: {
            if slot.isAvailable {
                selectedTimeSlot = slot
                print("Time slot selected: \(slot.startTime)")
            }
        }) {
            RoundedRectangle(cornerRadius: CornerRadius.small.value)
                .fill(selectedTimeSlot?.id == slot.id ? Color.surfaceBrandPrimary : .grey75)
                .overlay(
                    Text(formatTime(slot.startTime))
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(selectedTimeSlot?.id == slot.id ? .textInvert : slot.isAvailable ? .textPrimary : .textLight)
                        .padding()
                )
        }
        .disabled(!slot.isAvailable)
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}

#Preview {
    TherapistScheduleTimeView(
        viewModel: TherapistProfilePageService(clinicianId: "667ab297a0ada2dceea38f7f"),
        selectedTimeSlot: .constant(nil),
        selectedDate: Date()
    )
}
