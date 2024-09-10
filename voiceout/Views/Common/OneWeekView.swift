//
//  OneWeekView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/4/24.
//

import SwiftUI
struct OneWeekView: View {
    @State private var selectedDayIndices: Set<Int> = []
    var days: [Day]

    init() {
        let weekLabels: [LocalizedStringKey] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var tempDays: [Day] = []

        for label in weekLabels {
                    tempDays.append(Day(label: label))
        }

        self.days = tempDays
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    VStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                        Text(day.label)
                            .font(Font.typography(.bodyMediumEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(selectedDayIndices.contains(index) ? Color.textInvert : Color.textSecondary)
                    }
                    .padding(.horizontal, ViewSpacing.xsmall)
                    .padding(.vertical, ViewSpacing.medium)
                    .frame(height: 57, alignment: .center)
                    .background(selectedDayIndices.contains(index) ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
                    .cornerRadius(CornerRadius.medium.value)
                    .onTapGesture {
                        if selectedDayIndices.contains(index) {
                            selectedDayIndices.remove(index)
                        } else {
                            selectedDayIndices.insert(index)
                        }
                    }
                }
                .frame(width:46)
            }
            .padding(0)
            .cornerRadius(CornerRadius.xxxsmall.value)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.top, ViewSpacing.xxxsmall)
        .padding(.bottom, 0)
        .cornerRadius(CornerRadius.xxxsmall.value)
    }
}

#Preview {
    VStack {
        OneWeekView()
    }
}
