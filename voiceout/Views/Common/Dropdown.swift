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
    var label: String?
    var prefixIcon: String?
    let placeholder: String
    let options: [DropdownOption]
    var backgroundColor: Color = Color.surfacePrimaryGrey2
    var isRequiredField: Bool? = false
    var dividerIndex: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let label = label, !label.isEmpty {
                HStack(spacing: 0) {
                    Text(LocalizedStringKey(label))

                    if isRequiredField == true {
                        Text("*")
                    }
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.small)
            }

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
                        .rotationEffect(Angle(degrees: isOptionPresented ? 180 : 0))
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
            }
            .background(backgroundColor)
            .cornerRadius(CornerRadius.medium.value)
            .overlay(alignment: .top) {
                VStack {
                    if self.isOptionPresented {
                        Spacer(minLength: ViewSpacing.xxlarge)
                        DropdownList(
                            options: self.options,
                            onSelectedAction: { option in
                                self.isOptionPresented = false
                                self.selectionOption = option
                            },
                            backgroundColor: backgroundColor,
                            dividerIndex: dividerIndex
                        )
                    }
                }
                .padding(.top, -ViewSpacing.base)
            }
        }
        .zIndex(isOptionPresented ? 1 : 0)
    }
}

#Preview {
    Dropdown(
        selectionOption: .constant(nil),
        label: "location",
        prefixIcon: "lock",
        placeholder: "state_placeholder",
        options: DropdownOption.testAllMonths
    )
}
