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
    @State private var selectedDate: Date? = nil
    @State private var selectedTimeSlot: Slot? = nil
    @State private var activeTab: Tab?

    var body: some View {
        ZStack {
            BackgroundView(backgroundType: .surfacePrimaryGrey)
                .zIndex(0)

            VStack(spacing: 0) {
                stickyHeaderView
                    .frame(height: 44)
                    .zIndex(2)

                profileHeaderView
                    .padding(.top, ViewSpacing.xlarge)
                    .padding(.bottom, ViewSpacing.small)
                    .padding(.horizontal, ViewSpacing.medium)
                    .zIndex(1)

                let validClinicianId = !viewModel.clinicianId.isEmpty ? viewModel.clinicianId : "default_clinician"

                ScrollView {
                    VStack(spacing: ViewSpacing.medium) {
                        SegmentedTabView(
                            tabList: tabList,
                            panelList: [
                                AnyView(BasicInfoContentView()),
                                AnyView(ReviewsView()),
                                AnyView(
                                    ConsultationReservationView(
                                        clinicianId: validClinicianId,
                                        selectedDate: $selectedDate,
                                        selectedTimeSlot: $selectedTimeSlot
                                    )
                                    .environmentObject(viewModel)
                                    .environmentObject(router)
                                )
                            ],
                            horizontalSpacing: ViewSpacing.medium,
                            isUsePanelHeight: true
                        )
                        .frame(maxWidth: .infinity)

                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .onAppear {
            if activeTab == nil {
                activeTab = tabList.first
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
    
    private let tabList = [
        Tab(id: "basicInfo", name: NSLocalizedString("basic_info", comment: "基本信息")),
        Tab(id: "Reviews", name: NSLocalizedString("customer_reviews", comment: "客户评价")),
        Tab(id: "consultationReservation", name: NSLocalizedString("consultation_reservation", comment: "咨询预约"))
    ]
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
            .environmentObject(RouterModel())
            .environmentObject(TherapistProfilePageService())
            .environmentObject(DialogViewModel())
    }
}
