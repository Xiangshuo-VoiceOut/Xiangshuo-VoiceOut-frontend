//
//  TherapistScheduleCalendarView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI

struct TherapistScheduleCalendarView: View {
    @ObservedObject var viewModel: TherapistProfilePageService
    @Binding var selectedTimeSlot: Slot?
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            MonthHeader(viewModel: viewModel)
            CalendarGrid(viewModel: viewModel, selectedDate: $selectedDate)
        }
        .padding()
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .onAppear {
            viewModel.fetchAvailableDates()
        }
    }
}

struct MonthHeader: View {
    @ObservedObject var viewModel: TherapistProfilePageService

    var body: some View {
        HStack(alignment: .center) {
            Text(viewModel.currentYear)
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
            Text(viewModel.currentMonth)
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
            Spacer()
            HStack(alignment: .center, spacing: ViewSpacing.medium)  {
                Button(action: { viewModel.previousMonth() }) {
                    Image("left-arrow")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.grey500)
                }
                Button(action: { viewModel.nextMonth() }) {
                    Image("right-arrow")
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, ViewSpacing.medium)
        }
        .frame(alignment: .center)
    }
}

struct CalendarGrid: View {
    @ObservedObject var viewModel: TherapistProfilePageService
    @Binding var selectedDate: Date?

    var body: some View {
        VStack {
            WeekdaysHeader(weekdays: viewModel.weekdays)
            CalendarRows(viewModel: viewModel, selectedDate: $selectedDate)
        }
    }
}

struct WeekdaysHeader: View {
    let weekdays: [String]

    var body: some View {
        HStack(alignment: .center, spacing: ViewSpacing.small) {
            ForEach(weekdays, id: \.self) { day in
                VStack(alignment: .center, spacing: ViewSpacing.small) {
                    Text(day)
                        .font(Font.typography(.bodyMediumEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, ViewSpacing.small)
                .padding(.vertical, ViewSpacing.medium)
                .frame(width: 40, height: 57, alignment: .center)
            }
        }
        Image("separator")
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color(red: 0.96, green: 0.96, blue: 0.96), lineWidth: 1)
            )
    }
}

struct CalendarRows: View {
    @ObservedObject var viewModel: TherapistProfilePageService
    @Binding var selectedDate: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            ForEach(0..<rowCount(), id: \.self) { rowIndex in
                CalendarRow(
                    rowIndex: rowIndex,
                    days: viewModel.days,
                    selectedDate: $selectedDate,
                    viewModel: viewModel
                )
            }
        }
    }

    private func rowCount() -> Int {
        (viewModel.days.count / 7) + (viewModel.days.count % 7 > 0 ? 1 : 0)
    }
}

struct CalendarRow: View {
    let rowIndex: Int
    let days: [Day]
    @Binding var selectedDate: Date?
    @ObservedObject var viewModel: TherapistProfilePageService

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<7, id: \.self) { columnIndex in
                let index = rowIndex * 7 + columnIndex
                if index < days.count {
                    let day = days[index]
                    ZStack {
                        if selectedDate == day.date {
                            Circle()
                                .fill(Color.surfaceBrandPrimary)
                                .frame(width: 48, height: 48)
                        }

                        Text(day.label)
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(
                                selectedDate == day.date
                                    ? .textInvert
                                    : day.isPast
                                        ? .textLight
                                        : day.isAvailable
                                            ? .textPrimary
                                            : .textLight
                            )
                            .padding(ViewSpacing.xsmall)
                            .opacity(day.isPast ? 0.35 : 1.0)
                    }
                    .frame(width: 48, height: 48)
                    .onTapGesture {
                        if day.isAvailable {
                            print("Date selected:", day.date)
                            selectedDate = day.date
                            viewModel.fetchTimeSlots(for: day.date)
                        }
                    }
                } else {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    TherapistScheduleCalendarView(
        viewModel: TherapistProfilePageService(clinicianId: "667ab297a0ada2dceea38f7f"),
        selectedTimeSlot: .constant(nil),
        selectedDate: .constant(nil)
    )
}
