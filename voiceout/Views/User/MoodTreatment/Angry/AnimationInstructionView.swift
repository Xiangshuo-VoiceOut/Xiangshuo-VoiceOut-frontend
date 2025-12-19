//
//  AnimationInstructionView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/18/25.
//

import SwiftUI

struct AnimationInstructionView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption?) -> Void

    var body: some View {
        VStack(spacing: 0) {
            if let animation = question.animation {
                LottieView(animationName: animation, loopMode: .loop)
            }

            if let lines = question.texts {
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, ViewSpacing.large)
                }
            }
            
            if !question.options.isEmpty {
                ForEach(question.options) { option in
                    Button(action: { onSelect(option) }) {
                        Text(option.text)
                    }
                }
            }
        }
    }
}
