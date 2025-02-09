//
//  FAQService.swift
//  voiceout
//
//  Created by Yujia Yang on 2/8/25.
//

import Foundation

enum FAQError: Error {
    case invalidURL
    case requestFailed
    case decodingError
    case unknown
}

class FAQService {
    func fetchFAQs(completion: @escaping (Result<[FAQCategory], FAQError>) -> Void) {
        guard let url = URL(string: APIConfigs.userFAQURL) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data, let _ = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }

            do {
                let response = try JSONDecoder().decode(FAQResponse.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    func fetchConsultationSteps(questionID: String, completion: @escaping (Result<[FAQAnswer], FAQError>) -> Void) {
        guard let url = URL(string: "\(APIConfigs.userFAQURL)/\(questionID)") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data, let _ = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }

            do {
                let question = try JSONDecoder().decode(FAQQuestion.self, from: data)
                completion(.success(question.answers))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
