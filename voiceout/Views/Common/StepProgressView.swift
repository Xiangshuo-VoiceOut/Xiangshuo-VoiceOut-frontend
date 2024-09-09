//
//  StepProgressView.swift
//  voiceout
//
//  Created by J. Wu on 6/18/24.
//

import SwiftUI

struct StepProgressView: View {
    @Binding var totalSteps: Int
    @Binding var currentStep: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(0..<totalSteps), id: \.self) { step in
                if step == currentStep {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: ViewSpacing.base, height: ViewSpacing.base)
                } else {
                    Circle()
                        .stroke(Color.brandPrimary, lineWidth: StrokeWidth.width100.value)
                        .frame(width: ViewSpacing.base, height: ViewSpacing.base)
                }

                if step < totalSteps - 1 {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.brandPrimary)
                }

            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StepProgressView(totalSteps: .constant(7), currentStep: .constant(2))
}
