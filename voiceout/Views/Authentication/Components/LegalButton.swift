//
//  LegalButton.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/10/24.
//

import SwiftUI

struct LegalButton: View {
    @EnvironmentObject var dialogViewModel: DialogViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            Color
                .white
                .ignoresSafeArea()
            
            RadioButtonView(
                isSelected: $isSelected,
                labelView: AnyView(legalButtonLabel)
            )
            .onTapGesture {
                dialogViewModel.present(
                    with: .init(
                        content: AnyView(
                            LegalDialogContent(isSelected: $isSelected)
                        )
                    )
                )
            }
        }
        .popup(with: .DialogViewModel(dialogViewModel))
        .popup(with: .PopupViewModel(popupViewModel))
    }
}

private extension LegalButton {
    @ViewBuilder var legalButtonLabel: some View {
        Text("legal_button_text \(Text("registration_protocol").foregroundColor(Color(.link))) \(Text("privacy_policy").foregroundColor(Color(.link)))")
            .font(.typography(.bodySmall))
    }
}

struct LegalButton_Previews: PreviewProvider {
    static var previews: some View {
        LegalButton(isSelected: .constant(false))
            .environmentObject(DialogViewModel())
            .environmentObject(PopupViewModel())
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
