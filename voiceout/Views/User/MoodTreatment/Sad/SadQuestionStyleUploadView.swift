//
//  SadQuestionStyleUploadView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/19/25.
//

import SwiftUI
import PhotosUI

struct SadQuestionStyleUploadView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = true
    @State private var showCurrentText = true
    @State private var uploadedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageConfirmed = false
    @State private var skippedUpload = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        if skippedUpload && currentTextIndex == 0 {
            return "xxxxx那下次再分享吧！"
        }
        var text = texts[currentTextIndex]
        return text.replacingOccurrences(of: "，", with: "，\n")
            .replacingOccurrences(of: ",", with: ",\n")
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        return introTexts[0]
    }
    
    private var hasIntroText: Bool {
        return currentTextIndex == 0 && !currentIntroText.isEmpty
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.vertical, ViewSpacing.medium)
                                .padding(.horizontal, ViewSpacing.xxxsmall)
                            Spacer()
                        }
                        
//                        Button {
//                            isPlayingMusic.toggle()
//                        } label: {
//                            Image(isPlayingMusic ? "music" : "stop-music")
//                                .resizable()
//                                .frame(width: 48, height: 48)
//                        }
//                        .padding(.leading, ViewSpacing.medium)
                    }
                    .padding(.bottom, ViewSpacing.large)

                    if showCurrentText {
                        VStack(spacing: 0) {
                            VStack {
                                Text(currentText)
                                    .id(currentTextIndex)
                                    .font(.typography(.bodyMedium))
                                    .lineSpacing(22.4 - 16)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(minHeight: 22.4 * 2, alignment: .top)
                            
                            if hasIntroText && !imageConfirmed && !skippedUpload {
                                Color.clear
                                    .frame(height: 16)
                                
                                VStack {
                                    Text(currentIntroText)
                                        .id("intro-\(currentTextIndex)")
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(width: 358, height: 22, alignment: .center)
                                
                                Color.clear
                                    .frame(height: 73)
                                
                                uploadArea
                                    .padding(.bottom, ViewSpacing.xxxxlarge+2*ViewSpacing.xlarge)
                            }
                            
                            if skippedUpload {
                                Color.clear
                                    .frame(height: 370)
                                
                                HStack(spacing: 0) {
                                    Spacer()
                                    
                                    Button {
                                        onContinue()
                                    } label: {
                                        Text("继续")
                                            .font(.typography(.bodyMedium))
                                            .foregroundColor(.textBrandPrimary)
                                    }
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.vertical, ViewSpacing.small)
                                    .frame(width: 114, height: 38)
                                    .background(Color.white)
                                    .cornerRadius(CornerRadius.full.value)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, ViewSpacing.xxxxlarge+2*ViewSpacing.xlarge)
                            }
                            
                            if uploadedImage != nil && imageConfirmed {
                                uploadedImageView
                                    .padding(.top, ViewSpacing.medium)
                            }
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                uploadedImage = image
            }
            .ignoresSafeArea()
        }
    }
    
    private var uploadedImageView: some View {
        VStack(spacing: ViewSpacing.small) {
            Image(uiImage: uploadedImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 255, height: 228)
                .cornerRadius(CornerRadius.small.value)
                .clipped()
        }
    }
    
    private var uploadArea: some View {
        VStack(spacing: ViewSpacing.betweenSmallAndBase) {
            if let image = uploadedImage {
                VStack(spacing: 0) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 255, height: 228)
                        .cornerRadius(CornerRadius.small.value)
                        .clipped()
                    
                    Color.clear
                        .frame(height: 69)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width:58)
                        
                        Button {
                            showImagePicker = true
                        } label: {
                            Text("重新上传")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textBrandPrimary)
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 38)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        
                        Spacer()
                            .frame(width: 21)
                        
                        Button {
                            onContinue()
                        } label: {
                            Text("确认")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(Color.white)
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 38)
                        .background(Color.surfaceBrandPrimary)
                        .cornerRadius(CornerRadius.full.value)
                        
                        Spacer()
                            .frame(width: 51)
                    }
                    .padding(.horizontal, -ViewSpacing.medium)
                }
            } else {
                VStack(spacing: 0) {
                    Button {
                        showImagePicker = true
                    } label: {
                        VStack(spacing: ViewSpacing.betweenSmallAndBase) {
                            Image(systemName: "camera.fill")
                                .font(.typography(.headerSmall))
                                .foregroundColor(.textBrandPrimary)
                            
                            Text("点击上传照片")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textBrandPrimary)
                        }
                        .padding(.vertical, ViewSpacing.xxxlarge+ViewSpacing.xsmall+ViewSpacing.xxsmall+ViewSpacing.xxxsmall)
                        .padding(.horizontal, ViewSpacing.xxlarge+ViewSpacing.base)
                        .frame(width: 255, height: 228)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.small.value)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small.value)
                                .strokeBorder(Color.surfaceBrandPrimary, style: StrokeStyle(lineWidth: StrokeWidth.width100.value, dash: [5, 5]))
                        )
                    }
                    
                    Color.clear
                        .frame(height: 69)
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button {
                            skippedUpload = true
                        } label: {
                            Text("我还没给好吃的拍照")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textBrandPrimary)
                                .underline()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, -ViewSpacing.medium)
                }
            }
        }
    }
    
    private func showCameraPicker() {
        showImagePicker = true
    }
    
    private func showPhotoLibraryPicker() {
        showImagePicker = true
    }
    
    private func handleContinue() {
        if currentTextIndex < (question.texts?.count ?? 0) - 1 {
            currentTextIndex += 1
            showCurrentText = true
        } else {
            onContinue()
        }
    }
}

#Preview {
    SadQuestionStyleUploadView(
        question: MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 10,
            uiStyle: .styleUpload,
            texts: [
                "最近有没有吃到好吃的美食呀，和小云朵分享一下吧！",
                "Wow，照片里的食物看上去很香呢！",
                "我都开始馋了，你真的很会捕捉美食耶！",
                "看，生活中隐藏着这么多的小美好，回忆这些时刻总会让人感受到幸福呢，让我们一起，继续捕捉生活中的美好瞬间叭！"
            ],
            animation: nil,
            options: [],
            introTexts: ["上传一张今日美食叭～"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
}
