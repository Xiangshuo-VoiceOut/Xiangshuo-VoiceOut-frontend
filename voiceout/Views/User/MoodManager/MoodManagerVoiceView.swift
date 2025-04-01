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
    var onBack: () -> Void 
    @StateObject private var audioRecorder = AudioRecorderVM()
    @State private var isRecording = false

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
                        }) {
                            Circle()
                                .fill(Color.surfaceBrandPrimary)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    HStack(alignment: .center, spacing: 0) {
                                        Image("group")
                                            .frame(width: 18, height: 18)
                                    }
                                )
                        }

                        Spacer()

                        Button(action: {
                            if isRecording {
                                audioRecorder.stopRecording()
                            } else {
                                audioRecorder.startRecording()
                            }
                            isRecording.toggle()
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
                            audioRecorder.saveRecording()
                            showVoiceRecorder = false
                        }) {
                            Circle()
                                .fill(audioRecorder.hasRecording ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image("check-rounded")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(audioRecorder.hasRecording ? .grey50 : .grey200) 

                                )
                        }
                        .disabled(!audioRecorder.hasRecording)
                    }
                    .padding(.horizontal, 2 * ViewSpacing.xlarge)
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom,ViewSpacing.xlarge)
            }
        }
    }
}

struct MoodManagerVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        MoodManagerVoiceView(
            showVoiceRecorder: .constant(false),
            onBack: {} 
        )
    }
}
