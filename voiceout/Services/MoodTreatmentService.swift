//
//  MoodTreatmentService.swift
//  voiceout
//
//  Created by Yujia Yang on 7/14/25.
//

import Foundation

struct MoodTreatmentService {
    static let shared = MoodTreatmentService()
    private let baseURL = URL(string: "http://127.0.0.1:3000")!
    //private let baseURL = URL(string: "http://localhost:3000")!

    func fetchQuestion(id: Int) async throws -> MoodTreatmentQuestion {
        guard let url = URL(string: "/quiz/\(id)", relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.requestFailed(error)
        }
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(MoodTreatmentQuestion.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}
