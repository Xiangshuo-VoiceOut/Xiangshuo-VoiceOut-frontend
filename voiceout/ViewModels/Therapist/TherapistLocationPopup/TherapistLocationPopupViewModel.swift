//
//  TherapistLocationPopupViewModel.swift
//  TherapistLocationPopup
//
//  Created by 阳羽佳 on 7/16/24.
//

import SwiftUI

class TherapistLocationPopupViewModel: ObservableObject {
    @Published var currentView: Int = 1
    @Published var selectedRegion: String? = nil
    @Published var isPopupPresented: Bool = false
    @Published var selectedState: String? = nil
    @Published var selectedStateAbbreviation: String? = nil
    @Published var isDropdownOpened: Bool = false

    func handleAllow() {
        currentView = 2 // Switch to view2
    }

    func handleDisallow() {
        currentView = 3 // Switch to view3
    }

    func handleDisallowFromView2() {
        currentView = 3 // Switch to view3
    }

    func handleAllowOnce() {
        currentView = 0 // Dismiss the popup
    }

    func handleAllowWhileUsingApp() {
        currentView = 0 // Dismiss the popup
    }

    func selectRegion(_ region: String, abbreviation: String) {
        selectedRegion = region
        selectedStateAbbreviation = abbreviation
        if selectedRegion != nil {
            confirmRegionSelection()
        }
    }

    func confirmRegionSelection() {
        if selectedRegion != nil {
            isDropdownOpened = false
            // Perform any action needed on confirmation
        }
    }

    func showPopup() {
        isPopupPresented = true
    }

    func hidePopup() {
        isPopupPresented = false
    }
}
