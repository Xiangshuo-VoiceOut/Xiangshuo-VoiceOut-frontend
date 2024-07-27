//
//  TherapistLocationPopupViewModel.swift
//  TherapistLocationPopup
//
//  Created by Yujia Yang on 7/16/24.
//

import SwiftUI
import CoreLocation

class TherapistLocationPopupViewModel: ObservableObject {
    @Published var currentView: Int = 1
    @Published var selectedRegion: String? = nil
    @Published var isPopupPresented: Bool = false
    @Published var selectedState: String? = nil
    @Published var selectedStateAbbreviation: String? = nil
    @Published var isDropdownOpened: Bool = false
    @Published var clinicians: [Clinician] = []

    func handleAllow() {
        currentView = 2 
    }

    func handleDisallow() {
        currentView = 3
    }

    func handleAllowOnce() {
        currentView = 0
    }

    func handleAllowWhileUsingApp() {
        currentView = 0
    }

    func getStateFromLocation(_ location: CLLocationCoordinate2D) -> String {

        return "NY"
    }

    func confirmRegionSelection(state: String) {
        selectedRegion = state
        fetchClinicians(state: state)
    }

    func showPopup() {
        isPopupPresented = true
    }

    func hidePopup() {
        isPopupPresented = false
    }

    private func fetchClinicians(state: String) {
        guard let url = URL(string: "http://localhost:3000/api/profile?certification.certificationLocation=\(state)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let fetchedClinicians = try JSONDecoder().decode([Clinician].self, from: data)
                DispatchQueue.main.async {
                    self.clinicians = fetchedClinicians
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
