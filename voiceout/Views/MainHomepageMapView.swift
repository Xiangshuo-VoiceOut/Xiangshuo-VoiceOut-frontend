//
//  MainHomepageMapView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/25/25.
//

import SwiftUI

struct MainHomepageMapView: View {
    @State private var isNight = Date().currentHour < 6 || Date().currentHour >= 18
    @State private var showTaskAlert = false
    @State private var showBackpackAlert = false
    @Binding var showMapView: Bool
    @EnvironmentObject var router: RouterModel
    var onSelectRoute: (Route) -> Void = { _ in }
    let baseMapAspectRatio: CGFloat = 828 / 1792
    
    let topTriangleFrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.475, 0.19 + (37 + 8) / 844, 0.08, 0.08 * 13 / 45)
    let leftCloudFrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.080, 0.032, 0.4, 0.4 * 96 / 166)
    
    let house1FrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.38, -0.04, 0.38, 0.38)
    let house2FrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.19, 0.116, 0.38, 0.38)
    let house3FrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.53, 0.34, 0.28, 0.3)
    let house4FrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.29, 0.43, 0.38, 0.38)
    let house5FrameRatio: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.47, 0.72, 0.38, 0.38)
    
    let label2OffsetRatio: (CGFloat, CGFloat) = (0, -0.12)
    let label3OffsetRatio: (CGFloat, CGFloat) = (0, -0.125)
    let label4OffsetRatio: (CGFloat, CGFloat) = (0, -0.15)
    let label5OffsetRatio: (CGFloat, CGFloat) = (0, -0.15)
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack(alignment: .topLeading) {
                Color(red: 0.69, green: 0.89, blue: 0.94)
                    .ignoresSafeArea()
                
                Image("homepagemap")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth, height: screenHeight)
                    .padding(.top, 5 * ViewSpacing.betweenSmallAndBase)
                
                Button(action: {
                    withAnimation {
                        showMapView = false
                    }
                }) {
                    VStack(spacing: ViewSpacing.small) {
                        Image("cloud2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 63, height: 37)
                        Image("polygon2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 13)
                            .rotationEffect(.degrees(180))
                    }
                }
                .frame(width: screenWidth)
                .position(x: screenWidth / 2, y: 3 * ViewSpacing.betweenSmallAndBase)
                
                Group {
                    houseView("house-1", screenWidth, screenHeight, house1FrameRatio).zIndex(1)
                    houseView("house-2", screenWidth, screenHeight, house2FrameRatio).zIndex(2)
                    labeledHouseView(
                        "house-3",
                        "压力缓解",
                        screenWidth,
                        screenHeight,
                        house3FrameRatio,
                        label3OffsetRatio,
                        route: .stressReliefEntry
                    )
                    .zIndex(10)
                    labeledHouseView(
                        "house-4",
                        "心情管家",
                        screenWidth,
                        screenHeight,
                        house4FrameRatio,
                        label4OffsetRatio,
                        route: .moodManagerLoading
                    )
                    .zIndex(5)
                    labeledHouseView(
                        "house-5",
                        "我的",
                        screenWidth,
                        screenHeight,
                        house5FrameRatio,
                        label5OffsetRatio
                    ).zIndex(3)
                    Image("cloud2")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: screenWidth * leftCloudFrameRatio.2,
                            height: screenHeight * leftCloudFrameRatio.3
                        )
                        .offset(
                            x: screenWidth * leftCloudFrameRatio.0,
                            y: screenHeight * leftCloudFrameRatio.1
                        )
                        .zIndex(0)
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 50 {
                            withAnimation {
                                showMapView = false
                            }
                        }
                    }
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    func houseView(_ imageName: String, _ width: CGFloat, _ height: CGFloat, _ frameRatio: (CGFloat, CGFloat, CGFloat, CGFloat)) -> some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width * frameRatio.2, height: height * frameRatio.3)
        }
        .offset(x: width * frameRatio.0, y: height * frameRatio.1)
    }
    
    func labeledHouseView(
        _ imageName: String,
        _ label: String,
        _ width: CGFloat,
        _ height: CGFloat,
        _ frameRatio: (CGFloat, CGFloat, CGFloat, CGFloat),
        _ labelOffset: (CGFloat, CGFloat),
        route: Route? = nil
    ) -> some View {
        let houseContent = VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width * frameRatio.2, height: height * frameRatio.3)
            Text(label)
                .font(Font.typography(.bodyMediumEmphasis))
                .foregroundColor(.textPrimary)
                .padding(ViewSpacing.xsmall)
                .background(Color.white.opacity(0.5))
                .cornerRadius(CornerRadius.small.value)
                .offset(y: height * labelOffset.1)
        }
        
        if let route = route {
            return AnyView(
                Button {
                    withAnimation { showMapView = false }
                    onSelectRoute(route)
                } label: {
                    houseContent
                        .contentShape(Rectangle())
                }
                    .buttonStyle(.plain)
                    .offset(x: width * frameRatio.0, y: height * frameRatio.1)
            )
        } else {
            return AnyView(
                houseContent
                    .offset(x: width * frameRatio.0, y: height * frameRatio.1)
            )
        }
    }
}

#Preview {
    MainHomepageMapView(showMapView: .constant(true))
        .environmentObject(RouterModel())
}
