//
//  DropdownOptionViewModel.swift
//  TherapistLocationPopup
//
//  Created by 阳羽佳 on 7/19/24.
//
import Foundation
import SwiftUI

class LocationDropdownViewModel: ObservableObject {
    @Published var allStates: [DropdownOption] = []
    @Published var selectedState: DropdownOption?

    init() {
        loadOptions()
    }

    func loadOptions() {
        self.allStates = loadDropdownOptions()
    }

    func loadDropdownOptions() -> [DropdownOption] {
        guard let url = Bundle.main.url(forResource: "states", withExtension: "json") else {
            print("Failed to locate states.json in bundle.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let states = try JSONDecoder().decode([StateData].self, from: data)
            return states.map { DropdownOption(option: $0.name) }
        } catch {
            print("Failed to decode states.json: \(error.localizedDescription)")
            return []
        }
    }
}
