//
//  CooperationAgreementPopupContent.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/20/24.
//

import SwiftUI

struct CooperationAgreementPopupContent: View {
    @EnvironmentObject var dialogViewModel: DialogViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("therapist_cooperation_aggrement_popup_title")
                        .font(.typography(.bodyLarge))
                        .padding(.bottom, ViewSpacing.xlarge)
                    // Todo: replace with correct file once the file is ready
                    Text(readFile(fileName: "注册协议"))
                        .font(.typography(.bodySmall))
                }
                .padding(.horizontal, ViewSpacing.large)
                .padding(.vertical, ViewSpacing.xxxlarge)
            }
            
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let buttonWidth = screenWidth * 0.43
                    
                VStack {
                    Spacer()
                    
                    HStack(spacing: ViewSpacing.medium) {
                        ButtonView(
                            text: "disagree_short",
                            action: {
                                dialogViewModel.present(
                                    with: .init(
                                        content: AnyView(
                                            VStack(spacing: ViewSpacing.xlarge) {
                                                Text("therapist_cooperation_aggrement_disagree_warning")
                                                    .font(.typography(.bodyMedium))
                                                
                                                ButtonView(
                                                    text: "understood",
                                                    action: {
                                                        withAnimation(.spring()) {
                                                            dialogViewModel.dismiss()
                                                        }
                                                    },
                                                    maxWidth: .infinity
                                                )
                                            }
                                                .padding(.all, ViewSpacing.large)
                                        )
                                    )
                                )
                            },
                            variant: ButtonVariant.outline,
                            maxWidth: buttonWidth
                        )
                        
                        ButtonView(
                            text: "agree",
                            action: {
                                // Todo: redirect to next screen
                            },
                            maxWidth: buttonWidth
                        )
                    }
                    .padding(.all, ViewSpacing.medium)
                    .padding(.bottom, ViewSpacing.small)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .popup(with: .DialogViewModel(dialogViewModel))
    }
}

struct CooperationAgreementPopupContent_Previews: PreviewProvider {
    static var previews: some View {
        CooperationAgreementPopupContent()
            .environmentObject(DialogViewModel())
    }
}

