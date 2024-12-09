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

            GeometryReader { geometry in
                StickyHeaderView(
                    title: "voice_out",
                    leadingComponent: AnyView(
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: LogoSize.small)
                            .clipShape(Circle())
                    ),
                    trailingComponent: AnyView(
                        Button(action: {
                            router.navigateTo(.therapistLogin)
                        }) {
                            Text("login")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.black.opacity(0.69))
                        }
                    )
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height * 0.56
                )
            }

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
                    maxWidth: 281
                )
            }
            .frameStyle()
        }
        .environmentObject(popupViewModel)
        .popup(with: .popupViewModel(popupViewModel))
        .popup(with: .dialogViewModel(dialogViewModel))
    }

    func openCooperationAgreementPopupContent() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: .init(
                    content: AnyView(
                        CooperationAgreementPopupContent()
                            .environmentObject(dialogViewModel)
                    ),
                    hideCloseButton: true
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
