//
//  SegmentedButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/19/24.
//

import SwiftUI

struct SegmentedButtonView: View {
    @State private var selectedTab: String = "basicInfo"
    @State private var hasReviews: Bool? = nil

    var body: some View {
        let tabs: [Tab] = [
            Tab(id: "basicInfo", name: NSLocalizedString("basic_info", comment: "基本信息")),
            Tab(id: "Reviews", name: NSLocalizedString("customer_reviews", comment: "客户评价")),
            Tab(id: "consultationReservation", name: NSLocalizedString("consultation_reservation", comment: "咨询预约"))
        ]

        let panels: [AnyView] = [
            AnyView(BasicInfoContentView()),
            AnyView(
                Group {
                    if let hasReviews = hasReviews {
                        if hasReviews {
                            ReviewsView()
                        } else {
                            NoReviewsView()
                        }
                    }
                }
            ),
            AnyView(ConsultationReservationView())
        ]

        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.id) { tab in
                    Button(action: {
                        selectedTab = tab.id
                    }) {
                        Text(tab.name)
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(selectedTab == tab.id ? .textPrimary : .textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, ViewSpacing.small)
                            .background(
                                Capsule()
                                    .fill(selectedTab == tab.id ? Color.surfacePrimary : Color.surfacePrimaryGrey)
                            )
                    }
                }
            }
            .padding(ViewSpacing.xxxsmall)
            .background(
                Capsule()
                    .fill(Color.surfacePrimaryGrey)
            )

            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        if selectedTab == "basicInfo" {
                            panels[0]
                                .frame(minHeight: geometry.size.height)
                        } else if selectedTab == "Reviews" {
                            panels[1]
                                .frame(minHeight: geometry.size.height)
                        } else if selectedTab == "consultationReservation" {
                            panels[2]
                                .frame(minHeight: geometry.size.height)
                        }
                    }
                    .padding(.top,ViewSpacing.medium)
                }
                .background(Color.surfacePrimaryGrey2)
            }
        }
        .onAppear {
            fetchReviewsStatus()
        }
    }

    func fetchReviewsStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            hasReviews = true
        }
    }
}

#Preview {
    SegmentedButtonView()
}
