//
//  MoodManagerLoadingView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/6/25.
//

import SwiftUI

struct MoodManagerLoadingView: View {
    @EnvironmentObject var router: RouterModel
    @State private var selectedImage: String = "happy"

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfaceBrandTertiaryBlue
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "mood_manager_loading_title",
                    leadingComponent: AnyView(Spacer().frame(width: ViewSpacing.large)),
                    trailingComponent: AnyView(
                        Button(action: {
                            router.navigateTo(.moodHomepageLauncher)
                        }) {
                            Image("close")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.grey500)
                        }
                    ),
                    backgroundColor: Color.surfaceBrandTertiaryBlue
                )
                .frame(maxWidth: .infinity, minHeight: 44)
                
                VStack {
                    HStack {
                        Button(action: {
                            router.navigateTo(.moodCalendar)
                        }) {
                            VStack(alignment: .center, spacing: ViewSpacing.xxsmall) {
                                VStack(alignment: .center, spacing: 0) {
                                    Image("chart-histogram")
                                        .frame(width: 24, height: 24)
                                }
                                .padding(ViewSpacing.small)
                                .background(Color.surfaceBrandPrimary)
                                .cornerRadius(CornerRadius.medium.value)

                                Text(LocalizedStringKey("chart_histogram"))
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textBrandPrimary)
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                            }
                            .padding(.top, ViewSpacing.xxsmall)
                            .frame(width: 40, alignment: .top)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    
                    Text(LocalizedStringKey("mood_manager_loading_question"))
                        .font(Font.typography(.bodyLargeEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textBrandPrimary)
                        .padding(.vertical, ViewSpacing.large)
                    
                    Text(LocalizedStringKey("mood_manager_loading_instruction"))
                        .font(Font.typography(.bodySmall))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textSecondary)
                }
                
                ZStack {
                    RotatingWheelView(selectedImage: $selectedImage)
                }
                
                Button(action: {
                    router.navigateTo(.moodDiary(selectedImage: selectedImage))
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.surfacePrimary)
                            .frame(width: 72, height: 72)
                            .imageShadow()

                        VStack(spacing: 0) {
                            Image("arrow-right")
                                .frame(width: 24, height: 24)
                            
                            Text(LocalizedStringKey("next_step"))
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textBrandPrimary)
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.grey50, lineWidth: StrokeWidth.width200.value)
                    )
                }
                .frame(width: 72, height: 72)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct MoodManagerLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MoodManagerLoadingView()
            .environmentObject(RouterModel())
    }
}
