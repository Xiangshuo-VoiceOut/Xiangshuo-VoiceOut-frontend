//
//  StressReliefEntryView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/23/25.
//

import SwiftUI

enum ReliefRoute: String, CaseIterable, Identifiable {
    case garden
    case audio

    var id: String { rawValue }
    var titleKey: LocalizedStringKey {
        switch self {
        case .garden: return "cloud_garden"
        case .audio:  return "cloud_audio"
        }
    }
    var imageName: String {
        switch self {
        case .garden: return "cloud-garden"
        case .audio:  return "cloud-audio"
        }
    }
}

struct StressReliefEntryView: View {
    @EnvironmentObject var router: RouterModel
    @State private var selected: ReliefRoute = .garden
    @State private var hasLaunchedGarden = false
    @State private var hasLaunchedAudio = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color.surfaceBrandTertiaryPeach, location: 0.00),
                    .init(color: Color.grey50, location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(41)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: nil,
                    leadingComponent: nil,
                    trailingComponent: AnyView(
                        Button(action: {
                            router.popToRoot()
                            NotificationCenter.default.post(name: .reopenMap, object: nil)
                        }) {
                            Image("close")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.grey500)
                        }
                    ),
                    backgroundColor: .clear
                )
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                
                Image("calm")
                    .padding(.vertical, ViewSpacing.medium)
                    .frame(width: 168, height: 120)
                
                Text(LocalizedStringKey("stress_relief_main_title"))
                    .font(Font.typography(.headerSmall))
                    .foregroundColor(.textTitle)
                    .padding(.top, ViewSpacing.xlarge+ViewSpacing.betweenSmallAndBase+ViewSpacing.xsmall)
                
                Text(LocalizedStringKey("choose_relief_route"))
                    .font(Font.typography(.bodyLargeEmphasis))
                    .foregroundColor(.textSecondary)
                    .padding(.top, ViewSpacing.base+ViewSpacing.medium)
                
                HStack(spacing: ViewSpacing.xlarge+ViewSpacing.betweenSmallAndBase+ViewSpacing.xsmall) {
                    ForEach(ReliefRoute.allCases) { route in
                        Button(action: { selected = route }) {
                            VStack(spacing: ViewSpacing.base) {
                                ZStack(alignment: .topTrailing) {
                                    Image(route.imageName)
                                        .frame(width: 120, height: 160)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .inset(by: 1.5)
                                                .stroke(
                                                    selected == route
                                                    ? Color.borderValid
                                                    : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                    
                                    if selected == route {
                                        Image("selected")
                                            .frame(width: 24, height: 24)
                                            .offset(x: ViewSpacing.small, y: -ViewSpacing.small)
                                    }
                                }
                                
                                Text(route.titleKey)
                                    .font(Font.typography(.bodyMediumEmphasis))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 5*ViewSpacing.base)
                
                Spacer()
                
                ButtonView(
                    text: String(localized: "start_journey"),
                    action: startJourney,
                    variant: .solid,
                    theme: .action,
                    spacing: .small,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: .infinity,
                    suffixIcon: nil
                )
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.bottom, ViewSpacing.large)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            StressReliefBGMManager.shared.playGardenIfNeeded()
        }
    }
    
    private func startJourney() {
        switch selected {
        case .garden:
            let skip = hasLaunchedGarden
            router.navigateTo(.cloudGardenOnboarding(startIndex: 0, showSkip: skip))
            hasLaunchedGarden = true
        case .audio:
            let skip = hasLaunchedAudio
            router.navigateTo(.cloudAudioOnboarding(startIndex: 0, showSkip: skip))
            hasLaunchedAudio = true
        }
    }
}

struct StressReliefEntryView_Previews: PreviewProvider {
    static var previews: some View {
        StressReliefEntryView()
            .environmentObject(RouterModel())
    }
}
