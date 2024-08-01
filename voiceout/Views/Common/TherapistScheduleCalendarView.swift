//
//  TherapistScheduleCalendarView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//
import SwiftUI

struct TherapistScheduleCalendarView: View {
    @StateObject var viewModel = TherapistScheduleViewModel()
    @State private var navigateToTimeSelection = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    // Caption
                    HStack(alignment: .center) {
                        HStack(alignment: .firstTextBaseline, spacing: CornerRadius.small.value) {
                            Text(viewModel.currentMonth)
                                .font(Font.typography(.headerSmall))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey900)
                                .padding(.horizontal, ViewSpacing.small)
                                .padding(.vertical, ViewSpacing.xsmall)

                            Text(viewModel.currentYear)
                                .font(Font.typography(.bodyLarge))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey900)
                        }
                        .padding(0)
                        .frame(width: 215, alignment: .leading)
                        .cornerRadius(CornerRadius.xxxsmall.value)

                        Spacer()
                        HStack(alignment: .top) {
                            Button(action: {
                                viewModel.previousMonth()
                            }) {
                                Image(systemName: "chevron.left")
                                    .frame(width: 24, height: 25)
                                    .cornerRadius(0)
                                    .foregroundColor(.grey500)
                            }

                            Spacer()

                            Button(action: {
                                viewModel.nextMonth()
                            }) {
                                Image(systemName: "chevron.right")
                                    .frame(width: 24, height: 25)
                                    .cornerRadius(0)
                                    .foregroundColor(.grey500)
                            }
                        }
                        .padding(.leading, 0)
                        .padding(.trailing, 0)
                        .padding(.vertical, 0)
                        .frame(width: 48, alignment: .top)
                        .cornerRadius(CornerRadius.xxxsmall.value)
                    }
                    .padding(0)
                    .frame(width: 342, height: 53, alignment: .center)
                    .cornerRadius(CornerRadius.xxxsmall.value)

                    // Body
                    VStack(alignment: .leading, spacing: 0) {
                        CalendarGrid(viewModel: viewModel)
                    }
                    .padding(0)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                }
                .padding(ViewSpacing.medium)
                .cornerRadius(CornerRadius.medium.value)
            }
            .padding(0)
            .frame(width: 374, height: 419, alignment: .center)
            .cornerRadius(CornerRadius.xxxsmall.value)
            .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 8)
            .onAppear {
                //viewModel.loadTestData()
                viewModel.fetchAvailabilities()
            }
            .background(
                NavigationLink(
                    destination: TherapistScheduleTimeView(viewModel: viewModel, selectedDate: viewModel.selectedDate ?? Date()),
                    isActive: $navigateToTimeSelection,
                    label: {
                        EmptyView()
                    }
                )
            )
            .onChange(of: viewModel.selectedDate) { _ in
                navigateToTimeSelection = viewModel.selectedDate != nil
            }
        }
    }
}

struct CalendarGrid: View {
    @ObservedObject var viewModel: TherapistScheduleViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            // Weekdays
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.weekdays, id: \.self) { day in
                    VStack(alignment: .center, spacing: ViewSpacing.small) {
                        Text(day)
                            .font(Font.typography(.bodyMediumEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey900)
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, ViewSpacing.base)
                    .frame(width: 48, height: 46, alignment: .center)
                }
            }
            .padding(0)
            .frame(width: 342, height: 46, alignment: .top)
            .cornerRadius(CornerRadius.xxxsmall.value)

            // Separator
            Image("separator")
                .frame(width: 342)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(red: 0.96, green: 0.96, blue: 0.96), lineWidth: 1)
                )

            // Week
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<viewModel.days.count / 7 + (viewModel.days.count % 7 > 0 ? 1 : 0), id: \.self) { rowIndex in
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(0..<7, id: \.self) { columnIndex in
                            let index = rowIndex * 7 + columnIndex
                            if index < viewModel.days.count {
                                let day = viewModel.days[index]
                                ZStack {
                                    if viewModel.selectedDate == day.date {
                                        Circle()
                                            .fill(Color("brand-primary"))
                                            .frame(width: 48, height: 48)
                                    }
                                    Text(day.display)
                                        .font(Font.typography(.bodyLarge))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(viewModel.selectedDate == day.date ? Color(.grey50) : day.isPast ? Color(red: 0.62, green: 0.62, blue: 0.62) : day.isAvailable ? .textTitle : .gray)
                                        .padding(4)
                                        .opacity(day.isPast ? 0.35 : 1.0)
                                }
                                .frame(width: 48, height: 48)
                                .onTapGesture {
                                    if !day.isPast && day.isAvailable {
                                        viewModel.selectDate(day.date)
                                    }
                                }
                            } else {
                                Spacer()
                            }
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                }
            }
        }
    }
}

#Preview{
    TherapistScheduleCalendarView()
}
