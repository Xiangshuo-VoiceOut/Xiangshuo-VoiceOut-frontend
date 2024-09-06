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
        ZStack(alignment: .bottom) {
            Color
                .clear
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
            .padding(ViewSpacing.xxlarge)
        }
        .popup(with: .dialogViewModel(dialogViewModel))
        .popup(with: .popupViewModel(popupViewModel))
    }
}

private extension LegalButton {
    @ViewBuilder var legalButtonLabel: some View {
        Text("legal_button_text \(Text("registration_protocol").foregroundColor(.textInfo)) \(Text("privacy_policy").foregroundColor(.textInfo))")
            .font(.typography(.bodySmall))
    }
}

struct LegalButton_Previews: PreviewProvider {
    static var previews: some View {
        LegalButton(isSelected: .constant(false))
            .environmentObject(DialogViewModel())
            .environmentObject(PopupViewModel())
    }
}
