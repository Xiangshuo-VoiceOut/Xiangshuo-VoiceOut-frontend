//
//  OneWeekView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/4/24.
//

import SwiftUI

struct OneWeekView: View {
    @Binding var selectedDayIndices: Set<Int>
    private var chipWidth: CGFloat = 45

    init(selectedDayIndices: Binding<Set<Int>>) {
        self._selectedDayIndices = selectedDayIndices
    }

    var body: some View {
        GeometryReader { geomtry in
            HStack(spacing: (geomtry.size.width - chipWidth * 7) / 7) {
                ForEach(Array(Day.weekLabel.enumerated()), id: \.offset) { index, day in
                    Text(day.label)
                        .font(Font.typography(.bodyMediumEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedDayIndices.contains(index) ? Color.textInvert : Color.textSecondary)
                        .padding(.vertical, ViewSpacing.medium)
                        .frame(width: chipWidth, alignment: .center)
                        .background(selectedDayIndices.contains(index) ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
                        .cornerRadius(CornerRadius.medium.value)
                        .onTapGesture {
                            if selectedDayIndices.contains(index) {
                                selectedDayIndices.remove(index)
                            } else {
                                selectedDayIndices.insert(index)
                            }
                        }
                }
            }
            .frame(width: geomtry.size.width)
        }
        .frame(height: 57)
    }
}

struct OneWeekView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedDayIndices: Set<Int> = [1]

        var body: some View {
            OneWeekView(selectedDayIndices: $selectedDayIndices)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
