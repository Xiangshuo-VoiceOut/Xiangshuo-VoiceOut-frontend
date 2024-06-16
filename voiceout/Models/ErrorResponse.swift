//
//  ErrorResponse.swift
//  voiceout
//
//  Created by J. Wu on 5/25/24.
//

import Foundation

struct ErrorResponse: Codable {
    let errors: [ErrorDetail]
}

struct ErrorDetail: Codable {
    let msg: String
}
