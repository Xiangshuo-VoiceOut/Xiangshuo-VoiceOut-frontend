//
//  TherapistViewModel.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/8/24.
//

import Foundation

class ClinicianViewModel: ObservableObject {
    @Published var clinicians: [Clinician] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchClinicians(userId: String, certificationLocation: String, latitude: Double, longitude: Double, page: Int = 1, limit: Int = 5) {
        isLoading = true
        guard let url = URL(string: "http://localhost:4001/api/doctors/getDoctorInfoByState") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "userId": userId,
            "latitude": latitude,
            "longitude": longitude,
            "page": page,
            "limit": limit
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        } catch {
            self.isLoading = false
            self.errorMessage = "Error creating request body: \(error.localizedDescription)"
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    print("Network Error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                    print("No data received from server")
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Data: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ClinicianResponse.self, from: data)
                DispatchQueue.main.async {
                    self.clinicians = decodedResponse.data
                    self.errorMessage = nil
                    print("Decoded Clinicians: \(decodedResponse.data)")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding Error: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Failed JSON Response: \(jsonString)")
                    }
                }
            }
        }.resume()
    }
}
