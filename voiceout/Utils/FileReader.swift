//
//  FileReader.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/20/24.
//

import Foundation

public func readFile(fileName: String) -> String {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
        do {
            return try String(contentsOf: fileURL)
        } catch {
            return fileName + "not found"
        }
    }
    return ""
}
