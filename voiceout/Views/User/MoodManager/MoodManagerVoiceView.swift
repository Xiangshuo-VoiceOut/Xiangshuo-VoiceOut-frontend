//
//  MoodManagerVoiceView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/7/25.
//

import SwiftUI
import AVFoundation

struct MoodManagerVoiceView: View {
    @Binding var showVoiceRecorder: Bool
    @Binding var voiceUrl: String
    var onBack: () -> Void
    
    @StateObject private var audioRecorder = MoodManagerAudioRecorderVM()
    @State private var isRecording = false
    @State private var showAudioPlayback = false
    @State private var hasNewRecording = false
    
    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: ViewSpacing.large) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.surfaceBrandTertiaryGreen)
                        .frame(width: 180, height: 180)
                    
                    Text(audioRecorder.recordingTime)
                        .font(Font.typography(.bodyLargeEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textBrandPrimary)
                }
                
                Spacer()
                
                Image("waveform")
                    .frame(width: 120, height: 66)
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 88)
                        .background(Color.grey50)
                        .cornerRadius(CornerRadius.medium.value)
                        .padding(.horizontal, ViewSpacing.xlarge)
                    
                    HStack {
                        Button(action: {
                            audioRecorder.resetRecording()
                            voiceUrl = ""
                            showAudioPlayback = false
                            hasNewRecording = false
                        }) {
                            Circle()
                                .fill(Color.surfaceBrandPrimary)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image("group")
                                        .frame(width: 18, height: 18)
                                )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if isRecording {
                                audioRecorder.stopRecording()
                                isRecording = false
                                hasNewRecording = true
                                showAudioPlayback = true
                            } else {
                                audioRecorder.resetRecording()
                                audioRecorder.startRecording()
                                isRecording = true
                                hasNewRecording = false
                                showAudioPlayback = false
                                voiceUrl = ""
                            }
                        }) {
                            Circle()
                                .fill(Color.surfaceBrandPrimary)
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image("voice2")
                                        .frame(width: 15, height: 20)
                                )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            audioRecorder.saveRecording { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let filename):
                                        print("Save successfully，filename =", filename)
                                        voiceUrl = filename
                                        print("Final saved voiceUrl is: \(voiceUrl)")
                                        showVoiceRecorder = false
                                    case .failure(let error):
                                        print("Save failed:", error.localizedDescription)
                                    }
                                }
                            }
                        }) {
                            Circle()
                                .fill((audioRecorder.hasRecording && hasNewRecording) ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image("check-rounded")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor((audioRecorder.hasRecording && hasNewRecording) ? .grey50 : .grey200)
                                )
                        }
                        .disabled(!(audioRecorder.hasRecording && hasNewRecording))
                    }
                    .padding(.horizontal, 2 * ViewSpacing.xlarge)
                }
                .padding(.bottom, ViewSpacing.xlarge)
                
                AudioPlaybackView(
                    voiceUrl: voiceUrl,
                    localFileUrl: audioRecorder.localFileUrl,
                    isVisible: $showAudioPlayback
                )
                .padding(.horizontal,ViewSpacing.xlarge)
                .padding(.bottom,ViewSpacing.large)
                .onAppear {
                    print("Local recording URL = \(String(describing: audioRecorder.localFileUrl))")
                }
            }
        }
    }
}

struct MoodManagerVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        MoodManagerVoiceView(
            showVoiceRecorder: .constant(false),
            voiceUrl: .constant(""),
            onBack: {}
        )
    }
}
