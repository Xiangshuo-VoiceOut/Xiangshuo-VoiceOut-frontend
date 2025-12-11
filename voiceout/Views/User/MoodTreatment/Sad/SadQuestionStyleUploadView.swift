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
    @State private var skippedUpload = false // 用户点击了"我还没给好吃的拍照"
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        // 如果用户跳过了上传，替换为"xxxxx那下次再分享吧！"
        if skippedUpload && currentTextIndex == 0 {
            return "xxxxx那下次再分享吧！"
        }
        var text = texts[currentTextIndex]
        // 将逗号替换为逗号+换行符
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
                                .padding(.vertical, 15.569)
                                .padding(.horizontal, 0.842)
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
                    .padding(.bottom, 24) // 云朵和text之间：24px

                    // text区域 - 使用固定布局，确保各区域相对独立
                    if showCurrentText {
                        VStack(spacing: 0) {
                            // text区域 - 预留足够空间（假设最多4行），防止挤压下方内容
                            VStack {
                                Text(currentText)
                                    .id(currentTextIndex) // 添加key强制重新渲染
                                    .font(.system(size: 16, weight: .regular))
                                    .lineSpacing(22.4 - 16) // line-height: 140% = 22.4px, font-size: 16px
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0x49/255.0, green: 0x45/255.0, blue: 0x4F/255.0)) // #49454F
                                    .fixedSize(horizontal: false, vertical: true) // 确保多行文本正确显示
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(minHeight: 22.4 * 2, alignment: .top) // 预留2行的高度（22.4px * 2 = 44.8px）
                            
                            // text的最后一行和introtext之间：16px - 使用固定间距
                            if hasIntroText && !imageConfirmed && !skippedUpload {
                                Color.clear
                                    .frame(height: 16) // 固定间距16px
                                
                                // introtext区域 - 固定高度，确保位置不变
                                VStack {
                                    Text(currentIntroText)
                                        .id("intro-\(currentTextIndex)") // 添加key强制重新渲染
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0)) // #67B899
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true) // 确保多行文本正确显示
                                }
                                .frame(width: 358, height: 22, alignment: .center) // 固定高度，确保位置不变
                                
                                // introtext和图片上传区域之间：73px - 使用固定间距
                                Color.clear
                                    .frame(height: 73) // 固定间距73px
                                
                                // 图片上传区域
                                uploadArea
                                    .padding(.bottom, 188) // 上传区域底部距离屏幕底部188px
                            }
                            
                            // 如果用户跳过了上传，显示继续按钮
                            if skippedUpload {
                                Color.clear
                                    .frame(height: 73 + 228 + 69) // 占位，保持布局一致
                                
                                // 继续按钮区域
                                HStack(spacing: 0) {
                                    Spacer()
                                    
                                    Button {
                                        onContinue()
                                    } label: {
                                        Text("继续")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color(red: 0.4, green: 0.72, blue: 0.6)) // #67B899 绿字
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .frame(width: 114, height: 38)
                                    .background(Color.white) // 白底
                                    .cornerRadius(360)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 188)
                            }
                            
                            // 显示已上传的照片（在所有阶段都显示）
                            if uploadedImage != nil && imageConfirmed {
                                uploadedImageView
                                    .padding(.top, 16)
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
                .cornerRadius(8)
                .clipped()
        }
    }
    
    private var uploadArea: some View {
        VStack(spacing: 10) {
            if let image = uploadedImage {
                // 显示已上传的图片
                VStack(spacing: 0) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 255, height: 228)
                        .cornerRadius(8)
                        .clipped()
                    
                    // 重新上传按钮距离图片区域69px
                    Color.clear
                        .frame(height: 69)
                    
                    // 按钮区域 - 使用负padding抵消外层容器的padding，确保按钮位置相对于屏幕
                    HStack(spacing: 0) {
                        // 重新上传按钮距离屏幕左侧74px（需要减去外层容器的padding）
                        Spacer()
                            .frame(width: 74 - ViewSpacing.medium)
                        
                        Button {
                            showImagePicker = true
                        } label: {
                            Text("重新上传")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(width: 114, height: 38)
                        .background(Color(red: 0.98, green: 0.99, blue: 1.0)) // #FBFCFE
                        .cornerRadius(360)
                        
                        // 重新上传按钮距离确认按钮21px
                        Spacer()
                            .frame(width: 21)
                        
                        Button {
                            // 点击确认后，直接进入下一题，不做任何页面改动
                            onContinue()
                        } label: {
                            Text("确认")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(width: 114, height: 38)
                        .background(Color(red: 0.4, green: 0.72, blue: 0.6)) // #67B899
                        .cornerRadius(360)
                        
                        // 确认按钮距离屏幕右侧67px（需要减去外层容器的padding）
                        Spacer()
                            .frame(width: 67 - ViewSpacing.medium)
                    }
                    .padding(.horizontal, -ViewSpacing.medium) // 抵消外层容器的padding
                }
            } else {
                VStack(spacing: 0) {
                    // 上传按钮 - 直接打开图片选择器
                    Button {
                        showImagePicker = true
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
                            
                            Text("点击上传照片")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
                        }
                        .padding(.vertical, 95)
                        .padding(.horizontal, 69)
                        .frame(width: 255, height: 228)
                        .background(Color.surfacePrimary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        )
                    }
                    
                    // 重新上传按钮距离图片区域69px
                    Color.clear
                        .frame(height: 69)
                    
                    // 在按钮位置显示"我还没给好吃的拍照"，可以点击
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button {
                            skippedUpload = true
                        } label: {
                            Text("我还没给好吃的拍照")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
                                .underline()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, -ViewSpacing.medium) // 抵消外层容器的padding
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
