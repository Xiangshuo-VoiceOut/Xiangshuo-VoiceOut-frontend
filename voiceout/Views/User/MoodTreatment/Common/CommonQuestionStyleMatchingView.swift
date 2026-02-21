//
//  CommonQuestionStyleMatchingView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/25/25.
//

import SwiftUI

struct CommonQuestionStyleMatchingView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var selectedOptions: Set<String> = []
    @State private var showOptions = false
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
    }
    
    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width
            let screenHeight = proxy.size.height
            let isSmallScreen = screenHeight < 700
            
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(height: min(isSmallScreen ? 120 : 160, screenHeight * (isSmallScreen ? 0.15 : 0.18)))
                            .padding(.vertical, isSmallScreen ? ViewSpacing.small : ViewSpacing.xlarge)
                        Spacer()
                    }

                    VStack(spacing: isSmallScreen ? ViewSpacing.xsmall : ViewSpacing.small) {
                        if showCurrentText {
                            Text(currentText)
                                .font(.typography(.bodyLarge))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.bottom, isSmallScreen ? ViewSpacing.medium : ViewSpacing.large)
                                .fixedSize(horizontal: false, vertical: true)
                                .onAppear {
                                    if currentTextIndex == 0 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            showOptions = true
                                        }
                                    }
                                }
                        }
                        
                        if showOptions && currentTextIndex == 0 {
                            optionsArea(screenWidth: screenWidth, isSmallScreen: isSmallScreen)
                        }
                        
                        Spacer(minLength: ViewSpacing.xsmall)
                    }
                    
                    bottomButtonArea
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private func optionsArea(screenWidth: CGFloat, isSmallScreen: Bool) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: ViewSpacing.small), count: 3),
            spacing: isSmallScreen ? ViewSpacing.small : ViewSpacing.medium
        ) {
            ForEach(question.options, id: \.self) { option in
                OptionCircleView(
                    option: option.text,
                    isSelected: selectedOptions.contains(option.text),
                    screenWidth: screenWidth
                ) {
                    toggleSelection(option.text)
                }
            }
        }
        .padding(.horizontal, ViewSpacing.xlarge)
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if showCurrentText {
                Button("继续") {
                    AnalyticsManager.shared.logClick(
                        elementName: "continue_button",
                        screenName: "CommonQuestionStyleMatching",
                        additionalParams: [
                            "question_id": question.id,
                            "matched_count": selectedOptions.count
                        ]
                    )
                    handleContinue()
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .frame(width: 114, height: 44)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.full.value)
                .foregroundColor(.textBrandPrimary)
                .font(Font.typography(.bodyMedium))
                .kerning(0.64)
                .multilineTextAlignment(.center)
                .padding(.bottom, ViewSpacing.large)
            }
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
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

struct OptionCircleView: View {
    let option: String
    let isSelected: Bool
    let screenWidth: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            Button(action: onTap) {
                ZStack {
                    Text(option)
                        .font(.typography(.bodyMedium))
                        .minimumScaleFactor(0.6)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, ViewSpacing.xsmall)
                        .padding(.vertical, ViewSpacing.xxsmall)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(isSelected ? Color(red: 0xAF/255.0, green: 0xE2/255.0, blue: 0xFD/255.0) : Color(red: 0.99, green: 1, blue: 1))
                        .clipShape(Circle())
                }
                .overlay(
                    ZStack {
                        if !isSelected {
                            Image("curve")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5)
                                .offset(x: geo.size.width * 0.2, y: geo.size.width * 0.2)
                        } else {
                            Image("curve3")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(red: 0xC0/255.0, green: 0xE9/255.0, blue: 0xFF/255.0))
                                .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5)
                                .offset(x: geo.size.width * 0.2, y: geo.size.width * 0.2)
                        }
                        
                        if isSelected {
                            Image("curve2")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(red: 0xC0/255.0, green: 0xE9/255.0, blue: 0xFF/255.0))
                                .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.25)
                                .offset(x: -geo.size.width * 0.1, y: -geo.size.width * 0.3)
                        }
                    },
                    alignment: .center
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(ViewSpacing.xxsmall)
        .aspectRatio(1, contentMode: .fit)
    }
}
