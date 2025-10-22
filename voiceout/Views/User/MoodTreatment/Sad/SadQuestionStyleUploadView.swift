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
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
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
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                    // 打字完成后可以执行的操作
                                }
                                .id(currentTextIndex) // 添加key强制重新渲染
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if showCurrentText && hasIntroText && !imageConfirmed {
                            TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                // introtext打字完成后可以执行的操作
                            }
                            .id("intro-\(currentTextIndex)") // 添加key强制重新渲染
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6)) // #67B899
                            .multilineTextAlignment(.center)
                            .frame(width: 252, alignment: .center)
                            
                            // 上传区域
                            uploadArea
                        }
                        
                        // 显示已上传的照片（在所有阶段都显示）
                        if uploadedImage != nil && imageConfirmed {
                            uploadedImageView
                        }
                    }
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.bottom,ViewSpacing.xsmall+ViewSpacing.large)
                    
                    Spacer()
                    
                    if showCurrentText && !hasIntroText {
                        Button(isLastText ? "完成" : "继续") {
                            handleContinue()
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                    }
                    
                    if showCurrentText && hasIntroText && imageConfirmed {
                        Button(isLastText ? "完成" : "继续") {
                            handleContinue()
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $uploadedImage)
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("选择图片来源"),
                buttons: [
                    .default(Text("拍照")) {
                        showCameraPicker()
                    },
                    .default(Text("从相册选择")) {
                        showPhotoLibraryPicker()
                    },
                    .cancel(Text("取消"))
                ]
            )
        }
    }
    
    private var uploadedImageView: some View {
        VStack(spacing: ViewSpacing.small) {
            Image(uiImage: uploadedImage!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
    
    private var uploadArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            if let image = uploadedImage {
                // 显示已上传的图片
                VStack(spacing: ViewSpacing.small) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200, maxHeight: 200)
                        .cornerRadius(12)
                    
                    HStack(spacing: ViewSpacing.medium) {
                        Button("重新上传") {
                            showActionSheet = true
                        }
                        .font(.typography(.bodyMedium))
                        .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                        
                        Button("确认") {
                            imageConfirmed = true
                        }
                        .font(.typography(.bodyMedium))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .background(Color(red: 0.404, green: 0.722, blue: 0.6))
                        .cornerRadius(CornerRadius.full.value)
                    }
                }
            } else {
                // 上传按钮
                Button {
                    showActionSheet = true
                } label: {
                    VStack(spacing: ViewSpacing.small) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                        
                        Text("点击上传照片")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                    }
                    .frame(width: 200, height: 120)
                    .background(Color.surfacePrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 2)
                    )
                }
            }
        }
    }
    
    private func showCameraPicker() {
        // 这里可以集成相机功能
        showImagePicker = true
    }
    
    private func showPhotoLibraryPicker() {
        showImagePicker = true
    }
    
    private func handleContinue() {
        if currentTextIndex < (question.texts?.count ?? 0) - 1 {
            // 还有下一句文本
            currentTextIndex += 1
            showCurrentText = true  // 保持显示状态
            // 不清除上传的照片，让它在所有阶段都保持显示
        } else {
            // 所有文本都显示完了，进入下一题
            onContinue()
        }
    }
}

#Preview {
    SadQuestionStyleUploadView(
        question: MoodTreatmentQuestion(
            id: 5,
            totalQuestions: 10,
            type: .custom,
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
