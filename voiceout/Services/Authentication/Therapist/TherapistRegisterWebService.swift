//
//  TherapistRegisterWebService.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 11/10/24.
//

import Foundation

class TherapistRegisterWebService {
    func register(body: TherapistRegister) {
        let urlString = APIConfigs.therapistRegister
        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }

            guard response is HTTPURLResponse else {
                return
            }

            URLSession.shared.dataTask(with: request) {(data, response, error) in

                guard let data = data, error == nil else {
                    return
                }

                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    guard let response = try? JSONDecoder().decode(RegiserResponse.self, from: data), let token = response.token else {
                        return
                    }
                }
            }.resume()

        }
    }
}
