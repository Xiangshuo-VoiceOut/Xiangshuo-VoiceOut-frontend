//
//  SatisfactionView.swift
//  voiceout
//
//  Created by Yujia Yang on 12/12/24.
//

import SwiftUI

struct SatisfactionView: View {
    @Binding var overallSatisfaction: Int

    var body: some View {
        HStack(alignment: .center, spacing: ViewSpacing.medium) {
            ForEach(1...5, id: \.self) { index in
                VStack(spacing: ViewSpacing.small) {
                    Button(action: {
                        overallSatisfaction = index
                    }) {
                        Image(getSatisfactionImage(for: index))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(overallSatisfaction == index ? Color.surfacePrimary : .grey500)
                            .background(
                                overallSatisfaction == index ? Color.surfaceBrandPrimary : Color.clear
                            )
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(getSatisfactionText(for: index))
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(overallSatisfaction == index ? .textPrimary : .grey500)
                        .lineLimit(1)
                        .frame(width: 80, alignment: .center)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
private func getSatisfactionImage(for rating: Int) -> String {
        switch rating {
        case 1: return "Grinning-face-with-tightly-closed-eyes-open-mouth"
        case 2: return "Smiling-face-with-squinting-eyes"
        case 3: return "Emotion-happy"
        case 4: return "Emotion-unhappy"
        case 5: return "Angry-face"
        default: return ""
        }
    }

    private func getSatisfactionText(for rating: Int) -> String {
        switch rating {
        case 1: return "非常满意"
        case 2: return "满意"
        case 3: return "一般"
        case 4: return "不满意"
        case 5: return "非常不满意"
        default: return ""
        }
    }
}

struct SatisfactionView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(0) { binding in
            AnyView(SatisfactionView(overallSatisfaction: binding))
        }
        .previewLayout(.sizeThatFits)
    }
}

struct StatefulPreviewWrapper<Value>: View where Value: Equatable {
    @State private var value: Value
    let content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> AnyView) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
