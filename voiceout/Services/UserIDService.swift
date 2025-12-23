//
//  UserIDService.swift
//  voiceout
//
//  Created by Yujia Yang on 12/15/25.
//

import Foundation

struct ResolveUserIDRequest: Codable {
    let user_uuid: String
    let display_id: String
}

struct ResolveUserIDResponse: Codable {
    let user_id: String
    let is_new: Bool
}

enum UserIDServiceError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
}

enum IDDisplayMode {
    case displayID
    case userID
}

final class UserIDService {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func resolve(userUUID: String, displayID: String) async throws -> ResolveUserIDResponse {
        guard let url = URL(string: "\(baseURL)/user/resolve") else {
            throw UserIDServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ResolveUserIDRequest(
            user_uuid: userUUID,
            display_id: displayID
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw UserIDServiceError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            throw UserIDServiceError.httpError(http.statusCode)
        }

        return try JSONDecoder().decode(ResolveUserIDResponse.self, from: data)
    }
}
