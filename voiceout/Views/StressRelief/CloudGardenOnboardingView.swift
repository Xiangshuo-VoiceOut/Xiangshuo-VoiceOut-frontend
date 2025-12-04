//
//  CloudGardenOnboardingView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/23/25.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String?
    let text: LocalizedStringKey
    let buttonTitle: LocalizedStringKey
}

struct CloudGardenOnboardingView: View {
    @EnvironmentObject var router: RouterModel
    @Environment(\.presentationMode) var presentationMode
    private let startIndex: Int
    private let showSkip: Bool
    @State private var current: Int
    
    private let pages: [OnboardingPage] = [
        .init(imageName: nil,
              text: "garden_onboarding_1",
              buttonTitle: "tap_to_continue"),
        .init(imageName: nil,
              text: "garden_onboarding_2",
              buttonTitle: "tap_to_continue"),
        .init(imageName: nil,
              text: "garden_onboarding_3",
              buttonTitle: "tap_to_continue"),
        .init(imageName: nil,
              text: "garden_onboarding_4",
              buttonTitle: "tap_to_continue"),
        .init(imageName: nil,
              text: "garden_onboarding_5",
              buttonTitle: "tap_to_continue"),
        .init(imageName: nil,
              text: "garden_onboarding_6",
              buttonTitle: "tap_to_start_journey"),
        .init(imageName: nil,
              text: "garden_onboarding_7",
              buttonTitle: "tap_to_finish")
    ]
    
    init(startIndex: Int = 0, showSkip: Bool = false) {
        self.startIndex = startIndex
        self.showSkip = showSkip
        self._current = State(initialValue: startIndex)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("gardenonboarding-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Group {
                    Image("leaf").frame(width: 40, height: 40).offset(x: 5*ViewSpacing.base, y: -30*ViewSpacing.betweenSmallAndBase)
                    Image("flower-blue").frame(width: 65, height: 65).offset(x: -17*ViewSpacing.betweenSmallAndBase, y: ViewSpacing.betweenSmallAndBase)
                    Image("flower-pink").frame(width: 60, height: 60).offset(x: -10*ViewSpacing.betweenSmallAndBase, y: -22*ViewSpacing.betweenSmallAndBase)
                    Image("flower-yellow").frame(width: 60, height: 60).offset(x: 14*ViewSpacing.betweenSmallAndBase, y:-175)
                        .zIndex(1)
                    Image("flower-orange").frame(width: 60, height: 60).offset(x: 17*ViewSpacing.betweenSmallAndBase, y: 5*ViewSpacing.medium)
                    Image("leaf")
                        .frame(width: 40, height: 40)
                        .offset(x: 16*ViewSpacing.betweenSmallAndBase, y: 16*ViewSpacing.betweenSmallAndBase)
                        .rotationEffect(Angle(degrees: 70.49))
                }
                
                VStack {
                    Spacer()
                    Image("flowers-background")
                        .resizable()
                        .scaledToFit()
                }
                .ignoresSafeArea(edges: .bottom)
                
                VStack(spacing: 0) {
                    StickyHeaderView(
                        title: String(localized: "cloud_garden"),
                        leadingComponent: AnyView(Spacer().frame(width: 24)),
                        trailingComponent: AnyView(
                            Button { router.popToRoot() } label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.grey500)
                            }
                        ),
                        backgroundColor: .clear
                    )
                    .padding(.top, geo.safeAreaInsets.top)
                    .frame(maxWidth: .infinity)
                    
                    if showSkip {
                        HStack {
                            Spacer()
                            Button("skip") {
                                withAnimation { current = 5 }
                            }
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(.surfaceBrandPrimary)
                            .padding(.trailing, ViewSpacing.medium)
                        }
                        .padding(.top, ViewSpacing.medium)
                    }
                    
                    if let img = pages[current].imageName {
                        Image(img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 240, maxHeight: 240)
                            .padding(.bottom, ViewSpacing.base)
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 326, height: 108)
                            .offset(
                                x: ViewSpacing.xxxsmall + ViewSpacing.xxsmall,
                                y: ViewSpacing.small
                            )
                        
                        Image("polygon4")
                            .resizable()
                            .frame(width: 25, height: 22)
                            .offset(
                                x: -5 * ViewSpacing.base,
                                y: ViewSpacing.xxsmall + ViewSpacing.large
                            )
                            .opacity(0.4)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(pages[current].text)
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: 326 - 32, alignment: .leading)
                                .padding(.horizontal, ViewSpacing.xlarge)
                                .padding(.top, ViewSpacing.large)
                            
                            Button(action: goNext) {
                                Text(pages[current].buttonTitle)
                                    .font(Font.typography(.bodyXSmall))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                    .padding(
                                        .trailing,
                                        ViewSpacing.large + ViewSpacing.xxxsmall + ViewSpacing.xxsmall
                                    )
                                    .padding(.bottom, ViewSpacing.small)
                            }
                        }
                        .frame(width: 326, height: 108)
                        .background(Color.white)
                        .cornerRadius(28)
                        
                        Image("polygon4")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .offset(
                                x: -5 * ViewSpacing.base,
                                y: 2 * ViewSpacing.betweenSmallAndBase
                            )
                    }
                    .padding(.horizontal, ViewSpacing.medium+ViewSpacing.large)
                    .padding(.top, LogoSize.large+ViewSpacing.large+ViewSpacing.xlarge)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Image("calm")
                        .padding(.vertical, ViewSpacing.medium)
                        .frame(width: 168, height: 120)
                        .padding(.top, ViewSpacing.xlarge)
                        .scaleEffect(x: -1, y: 1)
                    
                    Image("cloud-shadow")
                        .renderingMode(.template)
                        .foregroundColor(
                            Color(red: 0.65, green: 0.65, blue: 0.65)
                                .opacity(0.45)
                        )
                        .frame(width: 94.5, height: 16.1)
                        .padding(.top, ViewSpacing.small)
                    
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
    
    private func goNext() {
        if current < 5 {
            withAnimation { current += 1 }
        } else if current == 5 {
            router.navigateTo(.cloudGardenJourney)
        } else {
            router.popToRoot()
        }
    }
}

struct CloudGardenOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CloudGardenOnboardingView(startIndex: 0, showSkip: false)
                .environmentObject(RouterModel())
            CloudGardenOnboardingView(startIndex: 0, showSkip: true)
                .environmentObject(RouterModel())
            CloudGardenOnboardingView(startIndex: 6, showSkip: false)
                .environmentObject(RouterModel())
        }
    }
}
