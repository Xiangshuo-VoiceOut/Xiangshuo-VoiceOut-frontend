//
//  LocalizationManager.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/8/24.
//

import SwiftUI

var localizedStringsCache: [String: String] = [:]

// Function to get a localized string with caching
func localizedString(forKey key: String, value: String? = nil, table: String? = nil) -> String {
    if let cachedString = localizedStringsCache[key] {
        return cachedString
    }

    let localizedString = NSLocalizedString(key, tableName: table, bundle: .main, value: value ?? "", comment: "")
    localizedStringsCache[key] = localizedString
    return localizedString
}
