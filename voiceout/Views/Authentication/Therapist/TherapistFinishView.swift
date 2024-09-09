//
//  TherapistFinishView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/6/24.
//
import SwiftUI

struct TherapistFinishView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject var dialogViewModel = DialogViewModel()
    @StateObject var popupViewModel = PopupViewModel()

    var body: some View {
        ZStack {
            BackgroundView()

            // TODO sdd sticky header

            VStack(spacing: ViewSpacing.xlarge) {
                Text("sign_up_successfully")
                    .font(.typography(.headerSmall))
                    .foregroundColor(Color.textPrimary)

                Text("therapist_finish_view_subheader")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.medium)

                ButtonView(
                    text: "confirm",
                    action: {
                        openCooperationAgreementPopupContent()
                    },
                    maxWidth: .infinity
                )
                .frame(width: 281)
            }
            .frameStyle()
        }
        .environmentObject(popupViewModel)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .popup(with: .popupViewModel(popupViewModel))
    }

    func openCooperationAgreementPopupContent() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: .init(
                    content: AnyView(
                        CooperationAgreementPopupContent()
                            .environmentObject(dialogViewModel)
                    )
                )
            )
        }
    }
}

#Preview {
    TherapistFinishView()
        .environmentObject(PopupViewModel())
        .environmentObject(DialogViewModel())
}
