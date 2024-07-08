//
//  AddButton.swift
//  voiceout
//
//  Created by J. Wu on 6/17/24.
//

import SwiftUI

struct AddButton: View {
    var action: () -> Void
    var text: String
    var body: some View {
        Button(action: action){
            HStack {
                Text(LocalizedStringKey(text))
                    .font(.typography(.bodyMedium))
                .foregroundColor(Color.textBrandPrimary)
                
                Image("add")
                    .foregroundColor(Color.textBrandPrimary)
            }
            .padding(.vertical, ViewSpacing.base)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(Color.brandTertiary)
        }
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.small.value)
                .stroke(.width100, Color.brandPrimary)
        )
    }
}

#Preview {
    AddButton(action: {}, text: "add_new_qualification")
}
