//
//  SegmentedButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/19/24.
//

import SwiftUI

struct SegmentedButtonView: View {
    @StateObject private var viewModel = TherapistProfilePageService()
    @EnvironmentObject var router: RouterModel
    var clinicianId: String

    @State private var selectedTab: String = "basicInfo"
    @State private var selectedDate: Date?
    @State private var selectedTimeSlot: Slot?

    var body: some View {
        VStack(spacing: 0) {
            TabButtonView()

            ScrollView {
                VStack {
                    TabContentView()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.bottom, ViewSpacing.medium+ViewSpacing.large)
                .padding(.top, ViewSpacing.medium)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    @ViewBuilder
    private func TabContentView() -> some View {
        switch selectedTab {
        case "basicInfo":
            BasicInfoContentView()
                .frame(maxWidth: .infinity)
                .background(Color.surfacePrimaryGrey2)

        case "Reviews":
            ReviewsView()

        case "consultationReservation":
            ConsultationReservationView(
                clinicianId: clinicianId,
                selectedDate: $selectedDate,
                selectedTimeSlot: $selectedTimeSlot
            )
            .environmentObject(router)
            .frame(maxWidth: .infinity)

        default:
            EmptyView()
        }
    }

    private func TabButtonView() -> some View {
        let tabs: [Tab] = [
            Tab(id: "basicInfo", name: NSLocalizedString("basic_info", comment: "基本信息")),
            Tab(id: "Reviews", name: NSLocalizedString("customer_reviews", comment: "客户评价")),
            Tab(id: "consultationReservation", name: NSLocalizedString("consultation_reservation", comment: "咨询预约"))
        ]
        
        return HStack(spacing: 0) {
            ForEach(tabs) { tab in
                Text(tab.name)
                    .font(.typography(.bodyMedium))
                    .foregroundColor(selectedTab == tab.id ? Color.textPrimary : Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ViewSpacing.small)
                    .padding(.horizontal, ViewSpacing.base)
                    .background(
                        Capsule()
                            .fill(selectedTab == tab.id ? Color.surfacePrimary : Color.clear)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.surfacePrimaryGrey, lineWidth: selectedTab == tab.id ? 0 : 1)
                    )
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedTab = tab.id
                        }
                    }
            }
        }
        .background(
            Capsule()
                .fill(Color.surfacePrimaryGrey)
        )
        .padding(.horizontal, ViewSpacing.medium)
    }
}

#Preview {
    SegmentedButtonView(clinicianId: "test_clinician_id")
        .environmentObject(TherapistProfilePageService())
}
