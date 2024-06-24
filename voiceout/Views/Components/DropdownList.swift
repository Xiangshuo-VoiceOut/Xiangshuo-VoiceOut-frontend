//
//  DropdownList.swift
//  voiceout
//
//  Created by J. Wu on 6/24/24.
//

import SwiftUI

struct DropdownList: View {
    let options: [DropdownOption]
    var body: some View {
        ScrollView{
            LazyVStack(alignment:.leading, spacing: ViewSpacing.xxsmall){
                ForEach(options) { option in
                    DropdownListRow(option:option)
                }
            }
        }
        .frame(height: 180) //TODO: Double Check
        .background(
            RoundedRectangle(cornerRadius: .medium)
                .fill(Color.surfacePrimaryGrey2)
        )
    }
}

#Preview {
    DropdownList(options: DropdownOption.testAllMonths)
}
