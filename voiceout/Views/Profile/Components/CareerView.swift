//
//  CareerView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import SwiftUI

struct TimelineItem {
    let title: String
    let subtitle: String?
    let description: String?
    let dateRange: String
}

struct TimelineView: View {
    var title: LocalizedStringKey
    var items: [TimelineItem]
    var showEditButton: Bool = false

    var body: some View {
        TherapistProfilePageCardView(title: title, showEditButton: showEditButton) {
            VStack(alignment: .leading, spacing: ViewSpacing.large) {
                ForEach(items, id: \.title) { item in
                    VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                        HStack(alignment: .top) {
                            Text(item.title)
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(item.dateRange)
                                .font(Font.typography(.bodyXSmallEmphasis))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.trailing)
                        }

                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(Font.typography(.bodyXSmallEmphasis))
                                .foregroundColor(.textSecondary)
                        }

                        if let description = item.description {
                            Text(description)
                                .font(Font.typography(.bodyXSmall))
                                .foregroundColor(.textPrimary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CareerView: View {
    var showEditButton: Bool

    var body: some View {
        let items = [
            TimelineItem(
                title: "NewYork-Presbyterian",
                subtitle: "PSYCHIATRIC NURSE PRACTITIONER",
                description: nil,
                dateRange: "2023年6月至今"
            ),
            TimelineItem(
                title: "北京大学学生心理健康教育与咨询中心实习生培养项目",
                subtitle: "实习生",
                description: nil,
                dateRange: "2020年6月至2021年5月"
            )
        ]

        TimelineView(title: "CareerExperience", items: items, showEditButton: showEditButton)
    }
}

struct CareerView_Previews: PreviewProvider {
    static var previews: some View {
        CareerView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
