//
//  DropdownListRow.swift
//  voiceout
//
//  Created by J. Wu on 6/24/24.
//

import SwiftUI

struct DropdownListRow: View {
    let option: DropdownOption
    var body: some View {
        Button(action: {}) {
            Text(option.option)
                .frame(maxWidth:.infinity, alignment: .leading)
                .foregroundColor(Color.textPrimary)
                .font(.typography(.bodyMedium))
                
                
        }
        .padding(.all,ViewSpacing.medium)
        
    }
}

#Preview {
    DropdownListRow(option: DropdownOption.testSingleMonth)
}
