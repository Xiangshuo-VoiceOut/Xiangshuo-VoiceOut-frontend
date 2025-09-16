//
//  MoodTreatmentService.swift
//  voiceout
//
//  Created by Yujia Yang on 7/14/25.
//

import Foundation

struct MoodTreatmentService {
    static let shared = MoodTreatmentService()
    private static let cloudURL = URL(string: "http://18.222.237.219:4000")!
    private static let simulatorLocalURL = URL(string: "http://127.0.0.1:3000")!
    private static var lanURL: URL? {
        if let raw = UserDefaults.standard.string(forKey: "dev.localBaseURL"),
           let url = URL(string: raw), !raw.isEmpty {
            return url
        }
        return nil
    }
    
    private static var candidateBaseURLs: [URL] {
#if targetEnvironment(simulator)
        return [cloudURL, cloudURL]
#else
        if let lan = lanURL {
            return [cloudURL, lan]
        } else {
            return [cloudURL]
        }
#endif
    }
    
    func fetchQuestion(routine: String, id: Int) async throws -> MoodTreatmentQuestion {
        try await tryAllBaseURLs { base in
            try await requestJSON(
                baseURL: base,
                path: "/quiz/\(routine)/\(id)",
                method: "GET",
                body: nil
            ) as MoodTreatmentQuestion
        }
    }
    
    func submitAnswer(
        userId: String,
        sessionId: String,
        questionId: Int,
        selectedOptionKey: String
    ) async throws -> MoodTreatmentQuestion {
        let body: [String: Any] = [
            "user_id": userId,
            "session_id": sessionId,
            "question_id": questionId,
            "selected_option": selectedOptionKey
        ]
        return try await tryAllBaseURLs { base in
            try await requestJSON(
                baseURL: base,
                path: "/quiz/answer",
                method: "POST",
                body: body
            ) as MoodTreatmentQuestion
        }
    }
    
    private func tryAllBaseURLs<T>(_ block: (_ base: URL) async throws -> T) async throws -> T {
        var lastError: Error?
        for base in Self.candidateBaseURLs {
            do {
                let value = try await block(base)
                return value
            } catch {
                lastError = error
            }
        }
        throw lastError ?? APIError.invalidResponse
    }
    
    private func requestJSON<T: Decodable>(
        baseURL: URL,
        path: String,
        method: String,
        body: [String: Any]?
    ) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        var req = URLRequest(url: url)
        req.httpMethod = method
        if let body = body {
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        let (data, resp): (Data, URLResponse)
        do {
            (data, resp) = try await URLSession.shared.data(for: req)
        } catch {
            throw APIError.requestFailed(error)
        }
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }
        do {
            let dec = JSONDecoder()
            return try dec.decode(T.self, from: data)
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
