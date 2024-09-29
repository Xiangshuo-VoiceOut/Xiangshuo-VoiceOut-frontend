//
//  Tab.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/19/24.
//

import Foundation

struct Tab: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
}

extension Tab {
    static let startEndTimes: [Tab] = [
        Tab(name: String(localized: "start_time")),
        Tab(name: String(localized: "end_time"))
    ]
}
