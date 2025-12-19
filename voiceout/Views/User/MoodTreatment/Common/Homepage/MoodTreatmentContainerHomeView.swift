//
//  MoodTreatmentContainerHomeView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodPageContainerView<Content: View>: View {
    let mood: String
    let onHealTap: () -> Void
    let content: Content
    let background: AnyView?
    @EnvironmentObject var router: RouterModel

    init(
        mood: String,
        onHealTap: @escaping () -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder background: () -> some View = { EmptyView() }
    ) {
        self.mood = mood
        self.onHealTap = onHealTap
        self.content = content()
        let bg = background()
        self.background = bg is EmptyView ? nil : AnyView(bg)
    }

    var body: some View {
        ZStack(alignment: .top) {
            moodColors[mood, default: .gray].ignoresSafeArea()

            if let background = background {
                background
                    .zIndex(1)
            }

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 44)
                    content
                    Spacer(minLength: ViewSpacing.xxsmall+ViewSpacing.medium)
                }
                .padding(.horizontal, ViewSpacing.medium)
                .zIndex(2)
            }

            StickyHeaderView(
                title: "疗愈云港",
                leadingComponent: AnyView(BackButtonView().foregroundColor(.grey500)
                ),
                trailingComponent: AnyView(
                    Button(action: {router.navigateTo(.mainHomepage) }) {
                        Image("close")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.grey500)
                    }
                ),
                backgroundColor: Color.clear
            )
            .frame(height: 44)
            .zIndex(0)
        }
    }
}

struct MoodIconBadge: View {
    let imageName: String
    let label: String

    var body: some View {
        VStack(spacing: ViewSpacing.xxsmall) {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(ViewSpacing.small)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)

            Text(label)
                .font(Font.typography(.bodyXXSmall))
                .kerning(0.3)
                .multilineTextAlignment(.center)
                .foregroundColor(.textInvert)
        }
        .frame(width: 40)
    }
}

#Preview("Happy") {
    MoodPageContainerView(
        mood: "happy",
        onHealTap: {},
        content: {
            Text("Each Mood Homepage")
        }
    )
}
