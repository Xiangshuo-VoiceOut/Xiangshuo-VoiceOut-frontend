//
//  TherapistScheduleCalendarView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI

struct TherapistScheduleCalendarView: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel

    var body: some View {
        VStack {
            MonthHeader(viewModel: viewModel)
            CalendarGrid(viewModel: viewModel)
        }
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct MonthHeader: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel

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
            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                Button(action: { viewModel.previousMonth() }) {
                    Image("left-arrow")
                        .renderingMode(.original)
                        .frame(width: 24, height: 24)
                }
                Button(action: { viewModel.nextMonth() }) {
                    Image("right-arrow")
                        .renderingMode(.original)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(.top, ViewSpacing.large)
        .padding(.horizontal, ViewSpacing.medium)
        .frame(alignment: .center)
    }
}

struct CalendarGrid: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel

    var body: some View {
        VStack(spacing: ViewSpacing.small) {
            WeekdaysHeader(weekdays: viewModel.weekdays)
                .frame(maxWidth: .infinity, alignment: .leading)

            CalendarRows(viewModel: viewModel)
                .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding(.bottom, ViewSpacing.medium)
        .padding(.horizontal, ViewSpacing.medium)
    }
}

struct WeekdaysHeader: View {
    let weekdays: [String]

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(Font.typography(.bodyMediumEmphasis))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textPrimary)
                    .frame(width: 48, height: 48)
            }
        }
        .padding(.horizontal, 0)

        Image("separator")
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.surfacePrimaryGrey, lineWidth: 1)
            )
    }
}

struct CalendarRows: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel

    var body: some View {
        VStack(spacing: ViewSpacing.small) {
            ForEach(0..<rowCount(), id: \.self) { rowIndex in
                CalendarRow(
                    rowIndex: rowIndex,
                    days: viewModel.days,
                    selectedDate: viewModel.selectedDate,
                    onSelectDate: { viewModel.selectDate($0) }
                )
            }
        }
        .padding(.horizontal, 0)

    }

    private func rowCount() -> Int {
        viewModel.days.count / 7 + (viewModel.days.count % 7 > 0 ? 1 : 0)
    }
}

struct CalendarRow: View {
    let rowIndex: Int
    let days: [Day]
    let selectedDate: Date?
    let onSelectDate: (Date) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
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
                            .multilineTextAlignment(.center)
                            .foregroundColor(selectedDate == day.date ? .textInvert : day.isPast ? .textLight : day.isAvailable ? .textPrimary : .textLight)
                            .opacity(day.isPast ? 0.35 : 1.0)
                    }
                    .frame(width: 48, height: 48)
                    .onTapGesture {
                        if !day.isPast && day.isAvailable {
                            onSelectDate(day.date)
                        }
                    }
                } else {
                    Spacer()
                        .frame(width: 48, height: 48)
                }
            }
        }
    }
}

#Preview {
    TherapistScheduleCalendarView(viewModel: TherapistScheduleViewModel())
}
