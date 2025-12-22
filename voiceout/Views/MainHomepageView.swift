//
//  MainHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/24/25.
//

import SwiftUI
import Foundation

extension Date {
    var currentHour: Int {
        return Calendar.current.component(.hour, from: self)
    }
}

struct MainHomepageView: View {
    @State private var isNight = Date().currentHour < 6 || Date().currentHour >= 18
    @State private var isChatMode = false
    @EnvironmentObject var router: RouterModel
    let iconItems: [(image: String, label: String, route: Route)] = [
//        ("chart-histogram 1", "云报", .moodCalendar),
//        ("love-time", "压力缓解", .stressReliefEntry)
    ]
    
    var body: some View {
        ZStack {
            Image(isNight ? "night" : "day")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            mainHomepageContentView
        }
    }
    
    var mainHomepageContentView: some View {
        VStack {
            HStack {
                if isNight {
                    Image("moon")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .padding(.leading, 2*ViewSpacing.xlarge+ViewSpacing.betweenSmallAndBase)
                        .padding(.top, 14*ViewSpacing.betweenSmallAndBase)
                }
                
                VStack(spacing: ViewSpacing.medium) {
                    ForEach(iconItems, id: \.image) { item in
                        Button {
                            router.navigateTo(item.route)
                        } label: {
                            VStack(spacing: 0) {
                                ZStack {
                                    Image("message-frame")
                                        .frame(width: 48, height: 48)
                                    Image(item.image)
                                        .frame(width: 24, height: 24)
                                }
                                Text(item.label)
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.grey500)
                                    .padding(.top,ViewSpacing.xsmall)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, ViewSpacing.medium)
                .padding(.top, ViewSpacing.xxsmall+2*ViewSpacing.xlarge)
            }
            
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white)
                    .frame(width: 326, height: 108)
                    .opacity(0.4)
                    .offset(x: ViewSpacing.xxxsmall+ViewSpacing.xxsmall, y: ViewSpacing.small)
                    .allowsHitTesting(false)

                Image("polygon4")
                    .resizable()
                    .frame(width: 25, height: 22)
                    .offset(x: -5*ViewSpacing.base, y: ViewSpacing.xxsmall+ViewSpacing.large)
                    .opacity(0.4)
                    .allowsHitTesting(false)

                VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                    Text("今天心情还好吗？我在这听你说～")
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textSecondary)
                        .padding(.leading, ViewSpacing.large+ViewSpacing.xsmall+ViewSpacing.xxsmall)

                    Button {
                        router.navigateTo(.moodManagerLoading2)
                    } label: {
                        HStack(spacing: ViewSpacing.xsmall) {
                            Text("进入小云朵的疗愈空间")
                                .font(Font.typography(.bodyXSmall))
                                .foregroundColor(.brandPrimary)
                            Image("right-arrow")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.brandPrimary)
                                .frame(width: 16, height: 16)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, ViewSpacing.large + ViewSpacing.xxxsmall + ViewSpacing.xxsmall)
                        .padding(.top, ViewSpacing.xxsmall+ViewSpacing.xsmall+ViewSpacing.xlarge)
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: 326, height: 108)
                .background(Color.white)
                .cornerRadius(28)

                Image("polygon4")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .offset(x: -5*ViewSpacing.base, y: 2*ViewSpacing.betweenSmallAndBase)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal, ViewSpacing.xlarge)
            .padding(.top,15*ViewSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            HStack(spacing: 0) {
                Image("cloud2")
                    .resizable()
                    .frame(width: 248, height: 144)
                    .padding(.horizontal, ViewSpacing.xxsmall)
                    .padding(.vertical, ViewSpacing.large)
            }
            .padding(.horizontal, 7*ViewSpacing.betweenSmallAndBase)
            .padding(.top, ViewSpacing.base+ViewSpacing.xlarge)
            
            Image("cloud-shadow")
                .resizable()
                .frame(width: 135, height: 23)
                .padding(.top, -ViewSpacing.xsmall)
            Spacer()
            
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        MainHomepageView()
            .environmentObject(RouterModel())
    }
}
