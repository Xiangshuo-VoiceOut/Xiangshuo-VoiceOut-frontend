//
//  DropdownListRow.swift
//  voiceout
//
//  Created by J. Wu on 6/24/24.
//

import SwiftUI

struct DropdownListRow: View {
    let option: DropdownOption
    let onSelectedAction: (_ option: DropdownOption) -> Void

    var body: some View {
        Button(action: {self.onSelectedAction(option)}) {
            Text(option.option)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.textPrimary)
                .font(.typography(.bodyMedium))
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.small)

    }
}

#Preview {
    DropdownListRow(option: DropdownOption.testSingleMonth) {_ in}
}
