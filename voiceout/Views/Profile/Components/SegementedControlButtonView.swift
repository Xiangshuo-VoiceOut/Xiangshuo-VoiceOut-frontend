//
//  SegmentedButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/19/24.
//

import SwiftUI

struct SegmentedButtonView: View {
    var body: some View {
        let tabs: [Tab] = [
            Tab(id: "basicInfo", name: "基本信息"),
            Tab(id: "customerReviews", name: "客户评价"),
            Tab(id: "consultationReservation", name: "咨询预约")
        ]
        let panels: [AnyView] = [
            AnyView(ProfilePageView()),
            AnyView(CustomerReviewsView()),
            AnyView(ConsultationReservationView())
        ]
        SegmentedTabView(tabList: tabs, panelList: panels)
    }
}

struct CustomerReviewsView: View {
    var body: some View {
        Text("客户评价内容")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.surfacePrimary)
    }
}

struct ConsultationReservationView: View {
    var body: some View {
        Text("咨询预约内容")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.surfacePrimary)
    }
}

#Preview {
    SegmentedButtonView()
}
