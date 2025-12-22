//
//  SadQuestionStyleMultichoiceView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/20/25.
//

import SwiftUI

struct SadQuestionStyleMultichoiceView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = true
    @State private var showCurrentText = true
    @State private var selectedOptions: Set<UUID> = []
    @State private var showOptions = false
    @State private var customInput1 = ""
    @State private var customInput2 = ""
    @State private var showCustomInput = false
    @State private var optionsConfirmed = false
    @State private var customOptions: [String] = []
    @State private var selectedCustomOptions: Set<String> = []
    
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
                        
//                        Button {
//                            isPlayingMusic.toggle()
//                        } label: {
//                            Image(isPlayingMusic ? "music" : "stop-music")
//                                .resizable()
//                                .frame(width: 48, height: 48)
//                        }
//                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                }
                                .id(currentTextIndex)
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if showCurrentText && !optionsConfirmed {
                            TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                            }
                            .id("intro-\(currentTextIndex)")
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(.textBrandPrimary)
                            .multilineTextAlignment(.center)
                            .frame(width: 252, alignment: .center)
                            
                            multichoiceOptionsArea
                        }
                        
                        if !selectedOptions.isEmpty && optionsConfirmed {
                            selectedOptionsView
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
                    
                    if showCurrentText && hasIntroText && optionsConfirmed {
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
    }
    
    private var multichoiceOptionsArea: some View {
        VStack(spacing: ViewSpacing.small) {
            ForEach(question.options.filter { $0.exclusive != true }) { option in
                let isSelected = selectedOptions.contains(option.id)
                Button {
                    if isSelected {
                        selectedOptions.remove(option.id)
                    } else {
                        selectedOptions.insert(option.id)
                    }
                } label: {
                    HStack {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? Color.surfaceBrandPrimary : Color.gray)
                            .font(.typography(.bodyLarge))

                        Text(option.text)
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.grey500)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .background(Color.surfacePrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.surfaceBrandPrimary : Color.gray.opacity(0.3), lineWidth: StrokeWidth.width100.value)
                    )
                }
            }
            
            customInputOptions
            
            if !selectedOptions.isEmpty || !selectedCustomOptions.isEmpty {
                Button("确认") {
                    optionsConfirmed = true
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(Color.white)
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.surfaceBrandPrimary)
                .cornerRadius(CornerRadius.full.value)
                .padding(.top, ViewSpacing.small)
            }
        }
    }
    
    private var customInputOptions: some View {
        VStack(spacing: ViewSpacing.small) {
            if !customOptions.contains(where: { $0.contains("一个新技能") }) {
                HStack {
                    Image(systemName: "circle")
                        .foregroundColor(Color.gray)
                        .font(.typography(.bodyLarge))
                    TextField("一个新技能", text: $customInput1)
                        .font(.typography(.bodySmall))
                        .foregroundColor(.grey500)
                        .focused($isTextFieldFocused)
                    
                    if !customInput1.isEmpty {
                        Button {
                            customOptions.append("一个新技能：\(customInput1)")
                            customInput1 = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.textBrandPrimary)
                                .font(.typography(.bodyLarge))
                        }
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: StrokeWidth.width100.value)
                )
            }
            
            if !customOptions.contains(where: { $0.contains("其他") }) {
                HStack {
                    Image(systemName: "circle")
                        .foregroundColor(Color.gray)
                        .font(.typography(.bodyLarge))
                    TextField("其他", text: $customInput2)
                        .font(.typography(.bodySmall))
                        .foregroundColor(.grey500)
                        .focused($isTextFieldFocused)
                    
                    if !customInput2.isEmpty {
                        Button {
                            customOptions.append("其他：\(customInput2)")
                            customInput2 = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.textBrandPrimary)
                                .font(.typography(.bodyLarge))
                        }
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: StrokeWidth.width100.value)
                )
            }
            
            ForEach(customOptions, id: \.self) { customOption in
                let isSelected = selectedCustomOptions.contains(customOption)
                Button {
                    if isSelected {
                        selectedCustomOptions.remove(customOption)
                    } else {
                        selectedCustomOptions.insert(customOption)
                    }
                } label: {
                    HStack {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? Color.textBrandPrimary : Color.gray)
                            .font(.typography(.bodyLarge))
                        Text(customOption)
                            .font(.typography(.bodySmall))
                            .foregroundColor(.grey500)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        Button {
                            customOptions.removeAll { $0 == customOption }
                            selectedCustomOptions.remove(customOption)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color.red)
                                .font(.typography(.bodyMedium))
                        }
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .background(Color.surfacePrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.textBrandPrimary : Color.gray.opacity(0.3), lineWidth: StrokeWidth.width100.value)
                    )
                }
            }
        }
    }
    
    private var selectedOptionsView: some View {
        VStack(spacing: ViewSpacing.small) {
            Text("我学了：")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textBrandPrimary)
                .multilineTextAlignment(.center)
            
            ForEach(question.options.filter { $0.exclusive != true && selectedOptions.contains($0.id) }) { option in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.textBrandPrimary)
                        .font(.typography(.bodyMedium))

                    Text(option.text)
                        .font(.typography(.bodySmall))
                        .foregroundColor(.grey500)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.textBrandPrimary, lineWidth: StrokeWidth.width100.value)
                )
            }
            
            ForEach(customOptions.filter { selectedCustomOptions.contains($0) }, id: \.self) { customOption in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.textBrandPrimary)
                        .font(.typography(.bodyMedium))

                    Text(customOption)
                        .font(.typography(.bodySmall))
                        .foregroundColor(.grey500)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.surfacePrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.textBrandPrimary, lineWidth: StrokeWidth.width100.value)
                )
            }
        }
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
    SadQuestionStyleMultichoiceView(
        question: MoodTreatmentQuestion(
            id: 6,
            totalQuestions: 10,
            uiStyle: .styleMultichoice,
            texts: ["事情并不总是一帆风顺的，偶尔的挫折反而是打磨自己的利器。愿意和小云朵分享一下在这个过程中都学到了什么嘛？"],
            animation: nil,
            options: [
                .init(key: "A", text: "看到事物的积极面", next: nil, exclusive: false),
                .init(key: "B", text: "调整自己的期望值", next: nil, exclusive: false),
                .init(key: "C", text: "提高了处理困难的能力", next: nil, exclusive: false),
                .init(key: "D", text: "增强了对自己的理解", next: nil, exclusive: false),
                .init(key: "E", text: "团队合作的能力", next: nil, exclusive: false),
                .init(key: "F", text: "变得更加坚强", next: nil, exclusive: false),
                .init(key: "G", text: "欣赏过程而非结果", next: nil, exclusive: false),
                .init(key: "confirm", text: "我选好了", next: nil, exclusive: true)
            ],
            introTexts: [""],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
}
