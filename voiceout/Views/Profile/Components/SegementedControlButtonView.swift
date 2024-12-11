//
//  SegmentedButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/19/24.
//

import SwiftUI

struct SegmentedButtonView: View {
    @State private var selectedTab: String = "basicInfo"
    @State private var hasReviews: Bool?

    var body: some View {
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

        SegmentedTabView(tabList: Tab.profile, panelList: panels, horizontalSpacing: ViewSpacing.medium)
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
