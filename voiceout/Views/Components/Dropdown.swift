//
//  Dropdown.swift
//  voiceout
//
//  Created by J. Wu on 6/23/24.
//

import SwiftUI

struct Dropdown: View {
    @State private var isOptionPresented: Bool = false
    @Binding var selectionOption: DropdownOption?
    var prefixIcon: String? = nil
    let placeholder: String
    let options: [DropdownOption]
    var body: some View {
        Button(action: {
            withAnimation {
                self.isOptionPresented.toggle()
            }
        }) {
            HStack {
                if let icon = prefixIcon {
                    Image(icon)
                        .foregroundColor(.grey500)
                }
                Text(selectionOption == nil ? placeholder : selectionOption!.option)
                    .foregroundColor(selectionOption == nil ? Color.textLight : Color.textPrimary)
                    .font(.typography(.bodyMedium))
                
                Spacer()
                
                Image("down")
                    
            }
        }
        .padding(.horizontal,ViewSpacing.medium)
        .padding(.vertical,ViewSpacing.base)
        .background(Color.surfacePrimaryGrey2)
        .cornerRadius(CornerRadius.medium.value)
        .overlay(alignment:.top){
            VStack{
                if self.isOptionPresented {
                    Spacer(minLength: ViewSpacing.xxlarge)
                    DropdownList(options: self.options)
                }
            }
            .padding(.vertical, ViewSpacing.xsmall)
        }
    
    }
}

#Preview {
    Dropdown(selectionOption: .constant(nil), prefixIcon: "lock", placeholder: "Select month", options: DropdownOption.testAllMonths)
        .padding()
}
