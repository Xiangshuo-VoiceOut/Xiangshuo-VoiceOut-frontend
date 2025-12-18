//
//  RoutineStartConfig.swift
//  voiceout
//
//  Created by Yujia Yang on 12/16/25.
//

import Foundation

enum Routine: String {
    case envy
    case guilt
    case angry
    case scare
    case sad
    case anxiety
}

struct RoutineStartConfig {
    static let firstQuestionId: [Routine: Int] = [
        .envy: 1001,
        .guilt: 201,
        .angry: 1,
        .sad: 401,
        .anxiety: 3001,
//        .scare: 148.1,
        .scare: 501
    ]

    static func id(for routine: Routine) -> Int {
        if let id = firstQuestionId[routine] { return id }
        assertionFailure("Missing firstQuestionId for routine: \(routine.rawValue)")
        return 1
    }
}
