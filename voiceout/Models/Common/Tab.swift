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
    var icon: String?
    
    static func ==(lhs: Tab, rhs: Tab) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension Tab {
    static let startEndTimes: [Tab] = [
        Tab(name: String(localized: "start_time")),
        Tab(name: String(localized: "end_time")),
        Tab(id: "week", name: String(localized: "week_title")),
        Tab(id: "month", name: String(localized: "month_title"))
    ]

    static let profile: [Tab] = [
        Tab(name: String(localized: "basic_info")),
        Tab(name: String(localized: "customer_reviews")),
        Tab(name: String(localized: "consultation_reservation"))
    ]

    static let bottomNavigationBar: [Tab] = [
        Tab(name: String(localized: "home"), icon: "home"),
        Tab(name: String(localized: "consultation"), icon: "toolkit"),
        Tab(name: String(localized: "notification"), icon: "message"),
        Tab(name: String(localized: "profile"), icon: "me")
    ]
}
