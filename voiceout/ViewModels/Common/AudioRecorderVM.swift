//
//  AudioRecorderVM.swift
//  voiceout
//
//  Created by Yujia Yang on 3/7/25.
//

import Foundation
import AVFoundation

class AudioRecorderVM: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var hasRecording = false
    @Published var recordingTime: String = "00:00:00"

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0

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
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("mood_diary_recording.m4a")
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
            recordingTime = "00:00:00"

            startTimer()
        } catch {
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
        recordingTime = "00:00:00"
    }

    func saveRecording() {
        print("Recording saved successfully！")
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
}
