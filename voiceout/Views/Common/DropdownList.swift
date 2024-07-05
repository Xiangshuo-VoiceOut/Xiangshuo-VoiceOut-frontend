//
//  DropdownList.swift
//  voiceout
//
//  Created by J. Wu on 6/24/24.
//

import SwiftUI

struct DropdownList: View {
    let options: [DropdownOption]
    let onSelectedAction: (_ option: DropdownOption) -> Void
    var isCardInput: Bool = false
    var body: some View {
        ScrollView{
            LazyVStack(alignment:.leading){
                ForEach(options) { option in
                    DropdownListRow(option:option, onSelectedAction: self.onSelectedAction, isCardInput: isCardInput)
                }
            }
        }
        .frame(height: CGFloat(self.options.count * 40 > 180 ? 180 : CGFloat(self.options.count * 40))) //TODO: Double Check
        .background(
            RoundedRectangle(cornerRadius: .medium)
                .fill(Color.surfacePrimaryGrey2)
        )
    }
}

#Preview {
    DropdownList(options: DropdownOption.testAllMonths, onSelectedAction: {_ in}, isCardInput: true)
}
