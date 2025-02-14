//
//  ProfilePageView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/27/24.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var viewModel = TherapistProfilePageService()
    @StateObject private var dialogViewModel = DialogViewModel()

    var body: some View {
        ZStack {
            Color.grey75.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                stickyHeaderView
                    .zIndex(2)
                    .frame(height: 44)

                profileHeaderView
                    .zIndex(1)
                    .padding(.top, ViewSpacing.xlarge)
                    .padding(.bottom, ViewSpacing.small)
                    .padding(.horizontal, ViewSpacing.medium)

                SegmentedButtonView(clinicianId: viewModel.clinicianId)
                    .environmentObject(viewModel)
                    .environmentObject(router)
                    .frame(maxWidth: UIScreen.main.bounds.width)
            }

            if case let .present(config) = dialogViewModel.action {
                ZStack {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)

                    VStack(spacing: ViewSpacing.large) {
                        config.content
                    }
                    .padding(ViewSpacing.large)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.medium.value)
                }
            }
        }
    }

    private var stickyHeaderView: some View {
        StickyHeaderView(
            title: viewModel.name,
            leadingComponent: AnyView(
                BackButtonView()
                    .foregroundColor(.grey500)
            ),
            trailingComponent: AnyView(
                Button(action: { print("Send button tapped") }) {
                    Image("send")
                        .foregroundColor(.grey500)
                }
            )
        )
    }

    private var profileHeaderView: some View {
        NameTagView(
            name: viewModel.name,
            consultingPrice: viewModel.consultingPrice,
            personalTitle: viewModel.personalTitle,
            imageUrl: viewModel.imageUrl,
            showEditButton: false,
            followButtonAction: { showFollowDialog() },
            isFollowing: viewModel.isFollowing
        )
        .padding(.vertical, ViewSpacing.small)
    }

    private func showFollowDialog() {
        let followDialog = FollowDialogContentView(isFollowing: $viewModel.isFollowing)
            .environmentObject(dialogViewModel)

        let config = DialogViewModel.Config(content: AnyView(followDialog))
        dialogViewModel.present(with: config)
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
            .environmentObject(RouterModel())
            .environmentObject(TherapistProfilePageService())
            .environmentObject(DialogViewModel())
    }
}
