//
//  MoodManagerService.swift
//  voiceout
//
//  Created by Yujia Yang on 3/24/25.
//

import Foundation

enum API {
    static let host = "http://34.220.10.242:3001"
    static let moodBase = "\(host)/api/mood"
    static let v1 = "\(host)/api/v1"
}

class MoodManagerService {
    static let shared = MoodManagerService()
    //    private let baseUrl = "http://localhost:3000/api/mood"
    private let baseUrl = API.moodBase
    private let userId = "user00123"

    func createDiaryEntry(entry: DiaryEntry, completion: @escaping (Result<DiaryEntryResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/entry") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(entry)
            
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            if let data = data, let raw = String(data: data, encoding: .utf8) {
                print("Diary Response (status=\(status)):\n\(raw)")
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(DiaryEntryResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchDiaryEntries(startDate: Date, endDate: Date, page: Int = 1, limit: Int = 20, completion: @escaping (Result<DiaryEntriesResponse, Error>) -> Void) {
        let start = startDate.iso8601
        let end = endDate.iso8601
        guard let url = URL(string: "\(baseUrl)/entries/\(userId)?page=\(page)&limit=\(limit)&start_date=\(start)&end_date=\(end)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)

                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    if let date = formatter.date(from: dateString) {
                        return date
                    }

                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to decode date string: \(dateString)")
                }

                let response = try decoder.decode(DiaryEntriesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchMoodStats(period: String, completion: @escaping (Result<MoodStatsResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/stats/\(userId)?period=\(period)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MoodStatsResponseWrapper.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension Date {
    var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
