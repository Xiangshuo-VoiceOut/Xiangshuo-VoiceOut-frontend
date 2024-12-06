//
//  TimeInputViewModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/29/24.
//

import Foundation
import SwiftUI

class TimeInputData: ObservableObject {
    @Published var selectedStartTime: Int = 9
    @Published var selectedEndTime: Int = 5
    @Published var selectedStartAmPm: String = "AM"
    @Published var selectedEndAmPm: String = "PM"
    @Published var timeRangeLabel: String = "9 AM - 5 PM"
    @Published var isValidTimeRange: Bool = true
}

class TimeInputViewModel: ObservableObject {
    @Published var week: [TimeInputData] = [TimeInputData()]
    @Published var timeInputsByDay: [[TimeInputData?]] = [
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()]
    ]

    func timeRangeLabel(with timeInput: TimeInputData) -> String {
        "\(timeInput.selectedStartTime) \(timeInput.selectedStartAmPm) - \(timeInput.selectedEndTime) \(timeInput.selectedEndAmPm)"
    }

    func addTimeInput(at index: Int) {
        week.insert(TimeInputData(), at: index + 1)
    }

    func removeTimeInput(at index: Int) {
        if week.count > 1 {
            week.remove(at: index)
        }
    }

    func updateTimeInputByDay(selectedDays: [Int]) {
        timeInputsByDay = timeInputsByDay.enumerated().map { (offset, _) in
            if selectedDays.contains(offset) {
                return timeInputsByDay[offset].isEmpty ? [TimeInputData()] : timeInputsByDay[offset]
            } else {
                return []
            }
        }
    }

    func addTimeInputByDay(at index: Int) {
        timeInputsByDay[index].append(TimeInputData())
    }

    func removeTimeInputByDay(at dayIndex: Int, index: Int) {
        if timeInputsByDay[dayIndex].count > 1 {
            timeInputsByDay[dayIndex].remove(at: index)
        }
    }

    func validateTimeRange(at index: Int) {
        if timeRangeValidator(week[index].timeRangeLabel) {
            week[index].isValidTimeRange = true
        } else {
            week[index].isValidTimeRange = false
        }
    }

    func validateTimeRangeByDay(dayIndex: Int, index: Int) {
        if let timeRangeLabel = timeInputsByDay[dayIndex][index]?.timeRangeLabel, !timeRangeLabel.isEmpty, timeRangeValidator(timeRangeLabel) {
            timeInputsByDay[dayIndex][index]?.isValidTimeRange = true
        } else {
            timeInputsByDay[dayIndex][index]?.isValidTimeRange = false
        }
    }
}
