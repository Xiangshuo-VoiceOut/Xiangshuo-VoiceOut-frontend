//
//  MoodManagerImageUploader.swift
//  voiceout
//
//  Created by Yujia Yang on 4/29/25.
//

import UIKit
import Foundation

struct MoodManagerImageUploader {

    static func saveImageToLocal(image: UIImage, fileName: String) -> URL? {
        let fileManager = FileManager.default
        let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docsDir.appendingPathComponent(fileName)

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("The image failed to be converted to JPEG")
            return nil
        }

        do {
            try data.write(to: fileURL)
            print("The picture has been saved locally: \(fileURL)")
            return fileURL
        } catch {
            print("Failed to save the picture.: \(error)")
            return nil
        }
    }

    enum UploadError: Error {
        case emptyResponse
        case unexpectedFormat
        case badURL
        case invalidImageData
    }

    private struct ImageMetaSaveResponse: Codable {
        struct Payload: Codable {
            let userId: String
            let format: String
            let filePath: String
            let _id: String?
        }
        let message: String?
        let data: Payload?
    }

    static func uploadImageFile(_ image: UIImage,
                                userId: String = "user123456",
                                format: String = "jpg",
                                serverBasePath: String = "/uploads",
                                completion: @escaping (Result<String, Error>) -> Void) {

        let fileName = "image_\(Date().timeIntervalSince1970).jpg"
        _ = saveImageToLocal(image: image, fileName: fileName)

        let serverFilePath = serverBasePath.hasSuffix("/")
            ? "\(serverBasePath)\(fileName)"
            : "\(serverBasePath)/\(fileName)"

        guard let url = URL(string: "\(API.v1)/upload-image") else {
            completion(.failure(UploadError.badURL)); return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "format": format,
            "filePath": serverFilePath
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            let status = (resp as? HTTPURLResponse)?.statusCode ?? -1
            guard let data = data, !data.isEmpty else {
                completion(.failure(UploadError.emptyResponse)); return
            }
            do {
                let decoded = try JSONDecoder().decode(ImageMetaSaveResponse.self, from: data)
                guard (200..<300).contains(status), let payload = decoded.data else {
                    completion(.failure(UploadError.unexpectedFormat)); return
                }

                let fullUrl: String
                if payload.filePath.lowercased().hasPrefix("http://") || payload.filePath.lowercased().hasPrefix("https://") {
                    fullUrl = payload.filePath
                } else {
                    fullUrl = "\(API.host)\(payload.filePath)"
                }
                completion(.success(fullUrl))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    static func reportImageMetadata(serverFilePath: String,
                                    userId: String = "user123456",
                                    format: String = "jpg",
                                    completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(API.v1)/upload-image") else {
            completion(.failure(UploadError.badURL)); return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "format": format,
            "filePath": serverFilePath
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            let status = (resp as? HTTPURLResponse)?.statusCode ?? -1
            guard let data = data, !data.isEmpty else {
                completion(.failure(UploadError.emptyResponse)); return
            }
            do {
                let decoded = try JSONDecoder().decode(ImageMetaSaveResponse.self, from: data)
                guard (200..<300).contains(status), let payload = decoded.data else {
                    completion(.failure(UploadError.unexpectedFormat)); return
                }
                let fullUrl: String
                if payload.filePath.lowercased().hasPrefix("http://") || payload.filePath.lowercased().hasPrefix("https://") {
                    fullUrl = payload.filePath
                } else {
                    fullUrl = "\(API.host)\(payload.filePath)"
                }
                completion(.success(fullUrl))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
