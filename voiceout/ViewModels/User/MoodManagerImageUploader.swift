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
        case invalidImageData
        case emptyResponse
        case unexpectedFormat
    }

    static func uploadImageFile(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        /// local ip, need to update in the future
        let url = URL(string: "http://192.168.1.71:4000/upload-image-file")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(UploadError.invalidImageData))
            return
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"upload.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Upload failed. No response data")
                completion(.failure(UploadError.emptyResponse))
                return
            }

            if let responseText = String(data: data, encoding: .utf8) {
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let filePath = json["filePath"] as? String {
                    let fullUrl = "http://192.168.1.71:4000\(filePath)"
                    print("Picture address: \(fullUrl)")
                    completion(.success(fullUrl))
                } else {
                    print("JSON decode failed")
                    completion(.failure(UploadError.unexpectedFormat))
                }
            } catch {
                print("JSON Decoding exception: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
