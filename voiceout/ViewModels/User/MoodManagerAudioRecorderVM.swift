//
//  MoodManagerAudioRecorderVM.swift
//  voiceout
//
//  Created by Yujia Yang on 3/7/25.
//

import Foundation
import AVFoundation

class MoodManagerAudioRecorderVM: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var hasRecording = false
    @Published var recordingTime: String = "00:00"
    @Published var localFileUrl: URL? = nil

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    var currentDurationSeconds: Int { Int(elapsedTime.rounded()) }

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session:", error.localizedDescription)
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("mood_diary_recording_\(Date().timeIntervalSince1970).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()

            isRecording = true
            hasRecording = false
            elapsedTime = 0
            recordingTime = "00:00"
            localFileUrl = audioFilename

            startTimer()
        } catch {
            print("Failed to start recording:", error.localizedDescription)
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        hasRecording = true
        stopTimer()
    }

    func resetRecording() {
        stopRecording()
        hasRecording = false
        recordingTime = "00:00"
        localFileUrl = nil
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
            self.recordingTime = self.formatTime(self.elapsedTime)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveRecording(completion: @escaping (Result<String, Error>) -> Void) {
        guard let recorder = audioRecorder else {
            completion(.failure(NSError(domain: "No recording available", code: -1)))
            return
        }

        let fileUrl = recorder.url
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            completion(.failure(NSError(domain: "File does not exist", code: -1)))
            return
        }
        completion(.success(fileUrl.lastPathComponent))
    }
    
    struct RecordingSaveResponse: Codable {
        struct Payload: Codable {
            let filePath: String
            let userId: String
            let format: String
            let uploadedAt: String?
            let _id: String?
            let __v: Int?
            let duration: Int?
        }
        let message: String?
        let data: Payload?
    }

    func reportRecordingMetadata(userId: String,
                                 serverFilePath: String,
                                 format: String = "m4a",
                                 duration: Int,
                                 completion: @escaping (Result<Void, Error>) -> Void) {

        guard let url = URL(string: "\(API.v1)/upload-recording") else {
            completion(.failure(NSError(domain: "Bad URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "userId": userId,
            "filePath": serverFilePath,
            "format": format,
            "duration": duration
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard let data = data, !data.isEmpty else {
                completion(.failure(NSError(domain: "EmptyResponseBody", code: status))); return
            }
            do {
                let resp = try JSONDecoder().decode(RecordingSaveResponse.self, from: data)
                guard (200..<300).contains(status), resp.data != nil else {
                    completion(.failure(NSError(domain: "UploadRecordingFailed", code: status))); return
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
