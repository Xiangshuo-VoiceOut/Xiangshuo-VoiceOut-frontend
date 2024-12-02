//
//  WeekMatrixView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 12/1/24.
//

import SwiftUI

struct WeekMatrixView: View {
    @State private var schedule: [[Int]] = [[], [9, 20], [], [], [], [11, 13], []]
    let labelWidth: CGFloat = 38
    let slotHeight: CGFloat = 23

    func isFilledSlot(row: Int, col: Int) -> Bool {
        return schedule[row].contains(col)
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("")
                        .frame(width: labelWidth, height: 18)
                    ForEach(Day.timeLabel) { time in
                        Text(time.label)
                            .frame(width: labelWidth, height: slotHeight)
                            .font(.typography(.bodyXSmall))
                            .foregroundColor(.textPrimary)
                    }
                }
                .padding(.trailing, ViewSpacing.xxsmall)

                ForEach(Array(Day.weekLabel.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 0) {
                        Text(day.label)
                            .frame(width: (geometry.size.width - labelWidth) / 7)
                            .font(.typography(.bodySmall))
                            .foregroundColor(.textPrimary)

                        ForEach(Day.timeLabel) { time in
                            Rectangle()
                                .fill(isFilledSlot(row: index, col: time.index) ? Color.surfaceBrandPrimary.opacity(0.4) : Color.surfacePrimary)
                                .frame(
                                    width: (geometry.size.width - labelWidth) / 7,
                                    height: slotHeight
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: .xxxsmall)
                                        .inset(by: 0.5)
                                        .stroke(
                                            Color.borderHairline,
                                            style: StrokeStyle(lineWidth: 1, dash: [2, 2])
                                        )
                                )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WeekMatrixView()
}
