//
//  OneWeekViewModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/29/24.
//

import Foundation

class OneWeekViewModel: ObservableObject {
    @Published var selectedDayIndices: Set<Int> = [0, 1, 2, 3, 4, 5, 6]

    func selectDays(at index: Int) {
        if selectedDayIndices.contains(index) {
            selectedDayIndices.remove(index)
        } else {
            selectedDayIndices.insert(index)
        }
    }
}
