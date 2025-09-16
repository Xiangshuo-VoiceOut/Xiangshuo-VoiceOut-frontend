//
//  MainHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/24/25.
//

import SwiftUI

extension Date {
    var currentHour: Int {
        return Calendar.current.component(.hour, from: self)
    }
}

struct MainHomepageView: View {
    @State private var isNight = Date().currentHour < 6 || Date().currentHour >= 18
    @State private var showTaskAlert = false
    @State private var showBackpackAlert = false
    @State private var isChatMode = false
    @StateObject private var popupViewModel = PopupViewModel()
    @State private var showMapView = false
    @EnvironmentObject var router: RouterModel
    
    var body: some View {
        ZStack {
            Image(isNight ? "night" : "day")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            if isChatMode {
                mainHomepageCloudChatView(isNight: isNight) {
                    isChatMode = false
                }
            } else {
                mainHomepageContentView
            }
            
            if showTaskAlert || showBackpackAlert {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                VStack(spacing: ViewSpacing.medium) {
                    Text(showTaskAlert ? "每日任务功能仍在开发中，\n尽情期待！" : "背包功能仍在开发中，\n尽情期待！")
                        .font(Font.typography(.bodyLargeEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                    
                    ButtonView(
                        text: "我知道了",
                        action: {
                            showTaskAlert = false
                            showBackpackAlert = false
                        },
                        variant: .solid,
                        theme: .action,
                        maxWidth: 342
                    )
                }
                .padding(ViewSpacing.large)
                .frame(width: 342)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
            }
        }
        .overlay(
            Group {
                if case let .present(config) = popupViewModel.action {
                    AnyView(
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                            .overlay(
                                VStack(spacing: 0) {
                                    Spacer(minLength: 2*ViewSpacing.xlarge)
                                    
                                    VStack(spacing: 0) {
                                        config.content
                                            .background(Color.surfacePrimary)
                                            .cornerRadius(20)
                                    }
                                    .transition(.move(edge: .bottom))
                                    .animation(.spring(), value: popupViewModel.action.isPresented)
                                }
                                    .ignoresSafeArea(edges: [.bottom])
                            )
                    )
                } else {
                    AnyView(EmptyView())
                }
            }
        )
        .fullScreenCover(isPresented: $showMapView) {
            MainHomepageMapView(showMapView: $showMapView)
                .environmentObject(router)
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
                    ForEach(0..<3) { index in
                        ZStack {
                            Image("message-frame")
                                .frame(width: 48, height: 48)
                            Group {
                                if index == 0 {
                                    Image("task")
                                        .frame(width: 22, height: 30.25)
                                        .offset(y: ViewSpacing.xxsmall)
                                        .onTapGesture { showTaskAlert = true }
                                } else if index == 1 {
                                    Image("backpack")
                                        .frame(width: 30, height: 30)
                                        .offset(y: ViewSpacing.xxsmall)
                                        .onTapGesture { showBackpackAlert = true }
                                } else {
                                    Image("message-surfacebrand")
                                        .frame(width: 28, height: 19.6)
                                        .offset(y: ViewSpacing.xsmall)
                                        .onTapGesture {
                                            showMessagePopup()
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, ViewSpacing.medium)
                .padding(.top, ViewSpacing.xxsmall+2*ViewSpacing.xlarge)
            }
            
            if !isChatMode {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white)
                        .frame(width: 326, height: 108)
                        .opacity(0.4)
                        .offset(x: ViewSpacing.xxxsmall+ViewSpacing.xxsmall, y: ViewSpacing.small)
                    Image("polygon4")
                        .resizable()
                        .frame(width: 25, height: 22)
                        .offset(x: -5*ViewSpacing.base, y: ViewSpacing.xxsmall+ViewSpacing.large)
                        .opacity(0.4)
                    VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                        Text("想和小云朵聊聊吗～")
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textSecondary)
                            .padding(.leading, ViewSpacing.large+ViewSpacing.xsmall+ViewSpacing.xxsmall)
                            .padding(.top, ViewSpacing.xxxsmall+ViewSpacing.medium+ViewSpacing.large)
                        Spacer()
                        Text("点击进入对话")
                            .font(Font.typography(.bodyXSmall))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                            .padding(.trailing, ViewSpacing.large+ViewSpacing.xxxsmall+ViewSpacing.xxsmall)
                            .padding(.bottom, ViewSpacing.small)
                            .onTapGesture {
                                withAnimation {
                                    isChatMode = true
                                }
                            }
                    }
                    .frame(width: 326, height: 108)
                    .background(Color.white)
                    .cornerRadius(28)
                    
                    Image("polygon4")
                        .resizable()
                        .frame(width: 29, height: 29)
                        .offset(x: -5*ViewSpacing.base, y: 2*ViewSpacing.betweenSmallAndBase)
                }
                .padding(.horizontal, ViewSpacing.xlarge)
                .padding(.top, ViewSpacing.base+ViewSpacing.xlarge)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
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
            
            if !isChatMode {
                VStack {
                    Image("polygon2")
                        .resizable()
                        .frame(width: 45, height: 13)
                        .rotationEffect(Angle(degrees: 0.52))
                    
                    Image("treasure-map")
                        .resizable()
                        .frame(width: 38, height: 44)
                }
                .padding(.bottom, ViewSpacing.medium+ViewSpacing.xlarge)
            }
        }
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -50 {
                        withAnimation {
                            showMapView = true   // 👈 triggers .fullScreenCover
                        }
                    }
                }
        )

    }
    
    private func showMessagePopup() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: PopupViewModel.Action.PopupConfig(
                    content: AnyView(messagePopupContent()),
                    hideCloseButton: false
                )
            )
        }
    }
    
    private func messagePopupContent() -> some View {
        VStack(spacing: 0) {
            StickyHeaderView(
                title: "消息",
                leadingComponent: AnyView(Spacer()),
                trailingComponent: AnyView(
                    Button(action: {
                        withAnimation(.spring()) {
                            popupViewModel.dismiss()
                        }
                    }) {
                        Image("close")
                            .foregroundColor(.grey500)
                    }
                ),
                backgroundColor: .surfacePrimary
            )
            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                Image("system-notification")
                    .frame(width: 48, height: 48)
                    .padding(.leading, ViewSpacing.medium)
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                        VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                            Text("系统消息")
                                .font(Font.typography(.bodyLargeEmphasis))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text("需要上传文件")
                                .font(Font.typography(.bodyLarge))
                                .kerning(0.54)
                                .foregroundColor(.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .frame(alignment: .topLeading)
                    
                    VStack(alignment: .trailing, spacing: ViewSpacing.xsmall) {
                        Text("16:33")
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textLight)
                            .frame(maxWidth: .infinity, alignment: .topTrailing)
                        VStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("3")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .foregroundColor(.textInvert)
                        }
                        .padding(.horizontal, ViewSpacing.xxsmall+ViewSpacing.xsmall)
                        .padding(.vertical, ViewSpacing.xxxsmall)
                        .frame(width: 24, height: 24, alignment: .center)
                        .background(Color.surfaceBrandPrimary)
                        .cornerRadius(12)
                    }
                    .padding(.trailing,ViewSpacing.medium)
                    .frame(alignment: .topTrailing)
                }
                .padding(.leading, ViewSpacing.xsmall)
                .padding(.trailing, ViewSpacing.xxsmall+ViewSpacing.xsmall)
                .frame(height: 54, alignment: .center)
            }
            .padding(.vertical, ViewSpacing.small)
            .background(.white)
            .cornerRadius(CornerRadius.medium.value)
            .padding(.horizontal, ViewSpacing.medium)
            .onTapGesture {
                withAnimation(.spring()) {
                    popupViewModel.dismiss()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.navigateTo(.systemMessageDetail)
                }
            }
            
            Spacer(minLength: ViewSpacing.xlarge)
            
        }
        .background(Color.surfacePrimary)
    }
}

struct mainHomepageCloudChatView: View {
    let isNight: Bool
    let onClose: () -> Void
    @EnvironmentObject var router: RouterModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    onClose()
                }) {
                    Image("left-arrow")
                        .foregroundColor(.grey50)
                        .padding(.leading,ViewSpacing.medium)
                }
                Spacer()
            }
            .padding(.top, 5*ViewSpacing.base)
            
            VStack(spacing: ViewSpacing.base) {
                HStack{
                    Image("cloud2")
                        .frame(width: 166, height: 96)
                    Spacer()
                }
                .padding(.vertical,ViewSpacing.medium)
                
                VStack(spacing: ViewSpacing.base) {
                    HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("今天过得怎么样？")
                                .font(Font.typography(.bodyMedium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey300)
                        }
                        .padding(ViewSpacing.small)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("很充实")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textInvert)
                        }
                        .padding(ViewSpacing.small)
                        .background(Color.surfaceBrandPrimary)
                        .cornerRadius(CornerRadius.medium.value)
                    }
                    
                    HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("有什么感受你想和我讲讲吗？")
                                .font(Font.typography(.bodyMedium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey300)
                        }
                        .padding(ViewSpacing.small)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("我有一些焦虑")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textInvert)
                        }
                        .padding(ViewSpacing.small)
                        .background(Color.surfaceBrandPrimary)
                        .cornerRadius(CornerRadius.medium.value)
                    }
                }
            }
            .padding(.horizontal,ViewSpacing.medium)
            
            Spacer()
            
            VStack(spacing: 0) {
                HStack(spacing: ViewSpacing.base) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.91, green: 0.91, blue: 0.92))
                            .frame(width: 34, height: 34)
                        Image("add-1")
                            .foregroundColor(Color(red: 0.49, green: 0.5, blue: 0.52))
                            .frame(width: 16, height: 16)
                    }
                    
                    HStack(spacing: 0) {
                        Text("iMessage")
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(Color(red: 0.77, green: 0.77, blue: 0.78))
                            .frame( alignment: .leading)
                            .padding(.leading, ViewSpacing.base)
                        
                        Spacer()
                        
                        Image("voice-1")
                            .frame(width: 16, height: 16)
                            .padding(.trailing, ViewSpacing.base)
                    }
                    .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 80)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.77, green: 0.77, blue: 0.78), lineWidth: StrokeWidth.width100.value)
                    )
                }
                .padding(.horizontal, ViewSpacing.base)
                .padding(.top, ViewSpacing.xxsmall+ViewSpacing.xsmall)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 67)
            }
            .background(Color.white)
        }
        .background(
            Image(isNight ? "chat-night-background" : "chat-day-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

#Preview {
    MainHomepageView()
        .environmentObject(RouterModel())
}
