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
}

class TimeInputViewModel: ObservableObject {
    @Published var timeInputs: [TimeInputData] = [TimeInputData()]
    @Published var timeInputsByWeek: [[TimeInputData?]] = [
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()],
        [TimeInputData()]
    ]

    func addTimeInput() {
        timeInputs.append(TimeInputData())
    }

    func removeTimeInput(at index: Int) {
        if timeInputs.count > 1 {
            timeInputs.remove(at: index)
        }
    }

    func updateTimeInputByDay(selectedDays: [Int]) {
        timeInputsByWeek = timeInputsByWeek.enumerated().map { (offset, _) in
            if selectedDays.contains(offset) {
                return timeInputsByWeek[offset].isEmpty ? [TimeInputData()] : timeInputsByWeek[offset]
            } else {
                return []
            }
        }
    }

    func addTimeInputByDay(at index: Int) {
        timeInputsByWeek[index].append(TimeInputData())
    }

    func removeTimeInputByDay(at dayIndex: Int, index: Int) {
        if timeInputsByWeek[dayIndex].count > 1 {
            timeInputsByWeek[dayIndex].remove(at: index)
        }
    }
}
