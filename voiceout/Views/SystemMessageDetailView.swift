//
//  SystemMessageDetailView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/1/25.
//

import SwiftUI

struct SystemMessageDetailView: View {
    @EnvironmentObject var router: RouterModel
    
    let messages: [SystemMessage] = [
        .init(dateLabel: nil, timeText: "16:33", title: "领取xxxx奖励", subtitle: "领取xxx奖励", iconName: "mission", tagText: "每日任务", actionText: "领取xxxx奖励"),
        .init(dateLabel: "08-27", timeText: nil, title: "预约成功提醒", subtitle: "咨询师AA", iconName: "time", tagText: "9月3日 周二  2:00-3:00 PM", actionText: "查看详情"),
        .init(dateLabel: "08-27", timeText: nil, title: "预约时间变更", subtitle: "咨询师AA", iconName: "time", tagText: "9月3日 周二  2:00-3:00 PM", actionText: "查看详情"),
        .init(dateLabel: "08-26", timeText: nil, title: "预约马上开始", subtitle: "咨询师AA", iconName: "time", tagText: "今天  2:00-3:00 PM", actionText: "查看详情")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            StickyHeaderView(
                title: "系统消息",
                leadingComponent: AnyView(
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Image("left-arrow")
                            .foregroundColor(.grey500)
                    }
                ),
                trailingComponent: AnyView(Spacer()),
                backgroundColor: .white
            )
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                        if let label = message.dateLabel {
                            Text(label)
                                .font(.typography(.bodySmall))
                                .foregroundColor(.textLight)
                                .padding(.top, ViewSpacing.medium)
                                .padding(.bottom, ViewSpacing.small)
                        }
                        
                        if let time = message.timeText {
                            Text(time)
                                .font(.typography(.bodySmall))
                                .foregroundColor(.textLight)
                                .padding(.top, ViewSpacing.medium)
                                .padding(.bottom, ViewSpacing.small)
                        }
                        
                        SystemMessageCardView(
                            title: message.title,
                            subtitle: message.subtitle,
                            iconName: message.iconName,
                            tagText: message.tagText,
                            actionText: message.actionText
                        )
                    }
                }
                .padding(.horizontal,ViewSpacing.medium)
            }
        }
        .background(Color.surfacePrimaryGrey2)
    }
}

struct SystemMessageCardView: View {
    var timeText: String?
    var title: String
    var subtitle: String
    var iconName: String
    var tagText: String
    var actionText: String
    
    var body: some View {
        HStack{
            if let timeText = timeText {
                Text(timeText)
                    .font(.typography(.bodySmall))
                    .foregroundColor(.textLight)
                    .frame(alignment: .topLeading)
            }
        }
        
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                Text(title)
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.black)
                    .frame(alignment: .topLeading)
                HStack(alignment: .center, spacing: ViewSpacing.base) {
                    Text(subtitle)
                        .font(.typography(.bodyXSmall))
                        .kerning(0.36)
                        .foregroundColor(.textPrimary)
                        .frame(alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .center, spacing: ViewSpacing.base) {
                    Image(iconName)
                        .frame(width: 24, height: 24)
                    Text(tagText)
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(ViewSpacing.medium)
            
            Divider()
                .padding(.horizontal,ViewSpacing.small)
            
            HStack(alignment: .center, spacing: ViewSpacing.small) {
                Text(actionText)
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.surfaceBrandPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(ViewSpacing.small)
            .frame(alignment: .leading)
        }
        .frame(alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct SystemMessage: Identifiable {
    let id = UUID()
    let dateLabel: String?
    let timeText: String?
    let title: String
    let subtitle: String
    let iconName: String
    let tagText: String
    let actionText: String
}

#Preview{
    SystemMessageDetailView()
}
