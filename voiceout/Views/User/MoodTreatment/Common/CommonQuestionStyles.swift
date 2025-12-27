//
//  CommonQuestionStyles.swift
//  voiceout
//
//  Created by Stan Huang
//

import SwiftUI

struct CommonQuestionStyles {
    @ViewBuilder
    static func view(
        for question: MoodTreatmentQuestion,
        onContinue: @escaping () -> Void,
        onSelect: @escaping ((MoodTreatmentAnswerOption) -> Void),
        @ObservedObject vm: MoodTreatmentVM
    ) -> some View {
        switch question.uiStyle {
        // Upload/Interactive (14)
        case .styleUpload:
            CommonQuestionStyleUploadView(question: question, onContinue: onContinue)
            
        // Interactive Dialogue (15)
        case .styleInteractiveDialogue:
            CommonQuestionStyleInteractiveDialogueView(question: question, onContinue: onContinue)
            
        // Fill in blank (16)
        case .styleFillInBlank:
            CommonQuestionStyleFillInBlankView(question: question, onContinue: onContinue)
        
        case .styleBottle, .scareStyleBottle:
            CommonQuestionStyleBottleView(question: question, onSelect: onSelect)
        
        // Bubble selection (19, 33, 34)
        case .styleMatching:
            CommonQuestionStyleMatchingView(question: question, onContinue: onContinue)
            
        case .styleRank:
            CommonQuestionStyleRankView(question: question, onContinue: onContinue, vm: vm)
        
        case .styleSlider:
            CommonQuestionStyleSliderView(question: question, onContinue: onContinue)
        
        case .styleIntensification:
            RelaxationVideoView(question: question, onSelect: onSelect)
        
        default:
            // Fallback for truly unhandled cases
            CommonQuestionFallbackView(question: question, onContinue: onContinue)
        }
    }
}

// MARK: - Fallback View
struct CommonQuestionFallbackView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Question Type: \(question.uiStyle.rawValue)")
                .font(.headline)
            
            if let texts = question.texts, !texts.isEmpty {
                ForEach(texts, id: \.self) { text in
                    Text(text)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Button("Continue") {
                onContinue()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
