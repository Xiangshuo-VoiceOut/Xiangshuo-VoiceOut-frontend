//
//  LegalDialogContent.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/18/24.
//

import SwiftUI

struct LegalDialogContent: View {
    @EnvironmentObject var dialogViewModel: DialogViewModel
    @EnvironmentObject var popupViewModel: PopupViewModel
    @Binding var isSelected: Bool

    let registrationProtocolLinkText = NSLocalizedString("registration_protocol", comment: "")
    let privacyPolicyLinkText = NSLocalizedString("privacy_policy", comment: "")

    var body: some View {
        VStack {
            Text("legal_dialog_content_title")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.medium)

            Text("legal_dialog_content \(Text("[\(registrationProtocolLinkText)](registrationProtocol)")) \(Text("[\(privacyPolicyLinkText)](privacyPolicy)"))")
                .tint(.textInfo)
                .font(.typography(.bodyXSmall))
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.large)
                .environment(\.openURL, OpenURLAction { url in
                    switch url.absoluteString {
                    case "registrationProtocol":
                        openRegistrationProtocolPopup()
                        return .handled
                    case "privacyPolicy":
                        openPrivacyPolicyPopup()
                        return .handled
                    default:
                        return .discarded
                    }
                })

            HStack {
                ButtonView(
                    text: "disagree",
                    action: {
                        withAnimation(.spring()) {
                            dialogViewModel.dismiss()
                        }
                    },
                    variant: ButtonVariant.outline
                )

                Spacer()

                ButtonView(
                    text: "agree",
                    action: {
                        withAnimation(.spring()) {
                            dialogViewModel.dismiss()
                        }
                        isSelected = true
                    }
                )
            }
        }
        .padding(ViewSpacing.large)
    }

    func openRegistrationProtocolPopup() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: .init(
                    content: AnyView(
                        LegalPopupContent(fileName: "注册协议", contentTitle: "registration_protocol_popup_title")
                    )
                )
            )
        }
    }

    func openPrivacyPolicyPopup() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: .init(
                    content: AnyView(
                        LegalPopupContent(fileName: "⽤户隐私政策", contentTitle: "privacy_policy_popup_title")
                    )
                )
            )
        }
    }
}

private extension LegalDialogContent {
    func parseLegalContent(fileName: String) -> String {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            do {
                return try String(contentsOf: fileURL)
            } catch {
                return "Legal document not found"
            }
        }
        return ""
    }
}

struct LegalDialogContent_Previews: PreviewProvider {
    static var previews: some View {
        LegalDialogContent(isSelected: .constant(false))
            .environmentObject(DialogViewModel())
            .environmentObject(PopupViewModel())
    }
}
