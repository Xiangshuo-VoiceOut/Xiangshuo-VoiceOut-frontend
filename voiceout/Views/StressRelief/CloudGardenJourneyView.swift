//
//  CloudGardenJourneyView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/23/25.
//

import SwiftUI

struct GuideStep: Identifiable {
    let id = UUID()
    let imageNames: [String]
    let imageSizes: [CGSize]
    let text: LocalizedStringKey
}

struct HighlightStep: Identifiable {
    let id = UUID()
    let spotPositions: [CGPoint]
    let flowerNames: [String]
    let maskText: LocalizedStringKey
    let flowerText: LocalizedStringKey
    let flowerTexts: [LocalizedStringKey]?

    init(
        spotPositions: [CGPoint],
        flowerNames: [String],
        maskText: LocalizedStringKey,
        flowerText: LocalizedStringKey,
        flowerTexts: [LocalizedStringKey]? = nil
    ) {
        self.spotPositions = spotPositions
        self.flowerNames   = flowerNames
        self.maskText      = maskText
        self.flowerText    = flowerText
        self.flowerTexts   = flowerTexts
    }
}

struct CloudGardenJourneyView: View {
    @EnvironmentObject var router: RouterModel
    
    private let guideSteps: [GuideStep] = [
        .init(
            imageNames: ["stress-relief1","stress-relief2"],
            imageSizes: [CGSize(width:150, height:150), CGSize(width:195, height:130)],
            text: "journey_guide_1"
        ),
        .init(
            imageNames: ["stress-relief3"],
            imageSizes: [CGSize(width:280, height:280)],
            text: "journey_guide_2"
        ),
        .init(
            imageNames: ["stress-relief4"],
            imageSizes: [CGSize(width:256, height:180)],
            text: "journey_guide_3"
        )
    ]
    
    private let highlightSteps: [HighlightStep] = [
        .init(
            spotPositions: [CGPoint(x:0.63,y:0.58)],
            flowerNames:   ["body-flower-pink2"],
            maskText:      "journey_mask_right_hand",
            flowerText:    "journey_flower_right_hand"
        ),
        .init(
            spotPositions: [CGPoint(x:0.58,y:0.51)],
            flowerNames:   ["body-flower-pink1"],
            maskText:      "journey_mask_forearm",
            flowerText:    "journey_flower_forearm"
        ),
        .init(
            spotPositions: [
                CGPoint(x:0.41,y:0.58),
                CGPoint(x:0.41,y:0.48),
                CGPoint(x:0.25,y:0.43), CGPoint(x:0.56,y:0.43),
                CGPoint(x:0.25,y:0.36), CGPoint(x:0.56,y:0.36),
                CGPoint(x:0.41,y:0.33),
                CGPoint(x:0.41,y:0.25),
                CGPoint(x:0.41,y:0.40),
                CGPoint(x:0.34,y:0.67), CGPoint(x:0.47,y:0.67),
                CGPoint(x:0.34,y:0.78), CGPoint(x:0.47,y:0.78),
                CGPoint(x:0.34,y:0.87), CGPoint(x:0.47,y:0.87)
            ],
            flowerNames: [
                "body-flower-yellow",
                "body-flower-pink2",
                "body-flower-red","body-flower-red",
                "body-flower-yellow","body-flower-yellow",
                "body-flower-pink1",
                "body-flower-orange",
                "body-flower-orange",
                "body-flower-yellow","body-flower-yellow",
                "body-flower-pink2","body-flower-pink2",
                "body-flower-red","body-flower-red"
            ],
            maskText:   "journey_mask_free_select",
            flowerText: "",
            flowerTexts: [
                "journey_flower_hip",
                "journey_flower_waist",
                "journey_flower_upper_arm",
                "journey_flower_shoulders",
                "journey_flower_neck",
                "journey_flower_head",
                "journey_flower_chest",
                "journey_flower_thigh",
                "journey_flower_calf",
                "journey_flower_feet"
            ]
        )
    ]
    
    private let pairedIndices: [Int:[Int]] = [
        2:[2,3], 3:[2,3],
        4:[4,5], 5:[4,5],
        9:[9,10],10:[9,10],
        11:[11,12],12:[11,12],
        13:[13,14],14:[13,14]
    ]
    
    private let textIndexMap: [Int:Int] = [
        0:0, 1:1,
        2:2, 3:2,
        4:3, 5:3,
        6:4,
        7:5,
        8:6,
        9:7,10:7,
        11:8,12:8,
        13:9,14:9
    ]
    
    @State private var guideIndex         = 0
    @State private var inHighlight        = false
    @State private var highlightIndex     = 0
    @State private var shownSteps         = Set<Int>()
    @State private var thirdTappedIndices = Set<Int>()
    @State private var currentSpotIndex: Int?
    @State private var step3MaskActive    = true
    @State private var isShowingCurrent   = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("gardenonboarding-background")
                    .resizable()
                    .cornerRadius(41)
                    .ignoresSafeArea()
                
                if !inHighlight {
                    let step = guideSteps[guideIndex]
                    VStack(spacing:0) {
                        if step.imageNames.count > 1 {
                            HStack(spacing:ViewSpacing.medium) {
                                ForEach(step.imageNames.indices, id:\.self) { i in
                                    Image(step.imageNames[i])
                                        .frame(width:step.imageSizes[i].width,
                                               height:step.imageSizes[i].height)
                                }
                            }
                        } else {
                            Image(step.imageNames[0])
                                .frame(width:step.imageSizes[0].width,
                                       height:step.imageSizes[0].height)
                        }
                        
                        Text(step.text)
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,ViewSpacing.medium)
                            .padding(.top,ViewSpacing.betweenSmallAndBase+ViewSpacing.xlarge)
                        
                        Spacer()
                    }
                    .padding(.top,LogoSize.large+ViewSpacing.large+ViewSpacing.xlarge)
                    .overlay(
                        Button {
                            if guideIndex < guideSteps.count-1 {
                                withAnimation { guideIndex += 1 }
                            } else {
                                inHighlight = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.surfacePrimary)
                                .shadow(color:.black.opacity(0.05), radius:8, x:0,y:2)
                                .frame(width:72, height:72)
                                .overlay(
                                    Image("check-rounded")
                                        .renderingMode(.template)
                                        .frame(width:30, height:30)
                                        .foregroundColor(.surfaceBrandPrimary)
                                )
                        }
                        .padding(.bottom, geo.safeAreaInsets.bottom+2*ViewSpacing.xlarge),alignment:.bottom)
                }
                
                if inHighlight {
                    let hstep = highlightSteps[highlightIndex]
                    
                    Image("body-silhouette")
                        .frame(width:276, height:547)
                    
                    ForEach(shownSteps.sorted(), id:\.self) { idx in
                        let s = highlightSteps[idx]
                        ForEach(s.spotPositions.indices, id:\.self) { j in
                            let p = s.spotPositions[j]
                            Image(s.flowerNames[j])
                                .frame(width:53, height:55)
                                .position(x: geo.size.width*p.x + ViewSpacing.xsmall+ViewSpacing.xlarge,
                                          y: geo.size.height*p.y + ViewSpacing.base)
                        }
                    }
                    
                    if highlightIndex == 2 {
                        ForEach(thirdTappedIndices.sorted(), id:\.self) { j in
                            let p = hstep.spotPositions[j]
                            Image(hstep.flowerNames[j])
                                .frame(width:53, height:55)
                                .position(x: geo.size.width*p.x + ViewSpacing.xsmall+ViewSpacing.xlarge,
                                          y: geo.size.height*p.y)
                        }
                    }
                    
                    ZStack {
                        if highlightIndex < 2 && !isShowingCurrent {
                            Color.black.opacity(0.25)
                                .ignoresSafeArea()
                            
                            ForEach(hstep.spotPositions, id:\.self) { pos in
                                Button {
                                    shownSteps.insert(highlightIndex)
                                    isShowingCurrent = true
                                } label: {
                                    Image("highlight")
                                        .frame(width:44, height:44)
                                }
                                .position(x: geo.size.width*pos.x,
                                          y: geo.size.height*pos.y)
                            }
                            
                            if let first = hstep.spotPositions.first {
                                Image("hand")
                                    .frame(width:36, height:36)
                                    .position(x: geo.size.width*first.x+ViewSpacing.xxxsmall+ViewSpacing.xxsmall+ViewSpacing.xxlarge,
                                              y: geo.size.height*first.y+ViewSpacing.xsmall+ViewSpacing.xlarge)
                                    .allowsHitTesting(false)
                            }
                            
                            VStack {
                                Spacer()
                                
                                Text(hstep.maskText)
                                    .font(Font.typography(.bodyLarge))
                                    .foregroundColor(.textTitle)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal,ViewSpacing.medium)
                                    .padding(.bottom, geo.safeAreaInsets.bottom + ViewSpacing.large)
                            }
                        }
                        else if highlightIndex == 2 && step3MaskActive {
                            Color.black.opacity(0.25).ignoresSafeArea()
                            VStack {
                                Spacer()
                                
                                Text(hstep.maskText)
                                    .font(Font.typography(.bodyLarge))
                                    .foregroundColor(.textTitle)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal,ViewSpacing.medium)
                                    .padding(.bottom, geo.safeAreaInsets.bottom + ViewSpacing.large)
                            }
                            
                            ForEach(hstep.spotPositions.indices, id:\.self) { i in
                                let pos = hstep.spotPositions[i]
                                Button {
                                    let group = pairedIndices[i] ?? [i]
                                    thirdTappedIndices.formUnion(group)
                                    currentSpotIndex = i
                                    step3MaskActive = false
                                } label: {
                                    Image("highlight")
                                        .frame(width:44, height:44)
                                }
                                .position(x: geo.size.width*pos.x,
                                          y: geo.size.height*pos.y)
                            }
                        }
                        else if highlightIndex == 2 && !step3MaskActive {
                            ForEach(hstep.spotPositions.indices, id:\.self) { i in
                                let pos = hstep.spotPositions[i]
                                Button {
                                    let group = pairedIndices[i] ?? [i]
                                    thirdTappedIndices.formUnion(group)
                                    currentSpotIndex = i
                                } label: {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width:44, height:44)
                                }
                                .position(x: geo.size.width*pos.x,
                                          y: geo.size.height*pos.y)
                            }
                        }
                        else if highlightIndex > 2 && !isShowingCurrent {
                            Color.clear.contentShape(Rectangle())
                                .onTapGesture {
                                    shownSteps.insert(highlightIndex)
                                    isShowingCurrent = true
                                }
                        }
                        
                        if highlightIndex == 2 && !step3MaskActive {
                            if let texts = hstep.flowerTexts,
                               let spot = currentSpotIndex,
                               let txtIdx = textIndexMap[spot] {
                                VStack {
                                    Spacer()
                                    
                                    Text(texts[txtIdx])
                                        .font(Font.typography(.bodyLarge))
                                        .foregroundColor(.textPrimary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal,ViewSpacing.medium)
                                        .padding(.bottom, geo.safeAreaInsets.bottom+ViewSpacing.medium)
                                }
                            }
                        }
                        else if isShowingCurrent && highlightIndex != 2 {
                            VStack {
                                Spacer()
                                Text(hstep.flowerText)
                                    .font(Font.typography(.bodyLarge))
                                    .foregroundColor(.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal,ViewSpacing.medium)
                                    .padding(.bottom, geo.safeAreaInsets.bottom+ViewSpacing.medium)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if highlightIndex == 2,
                           thirdTappedIndices.count == hstep.spotPositions.count {
                            router.navigateTo(.cloudGardenOnboarding(startIndex: 6, showSkip: false))
                        }
                        else if highlightIndex != 2 && isShowingCurrent {
                            isShowingCurrent = false
                            if highlightIndex < highlightSteps.count - 1 {
                                highlightIndex += 1
                            } else {
                                router.navigateTo(.cloudGardenOnboarding(startIndex: 6, showSkip: false))
                            }
                        }
                    }
                }
                
                VStack {
                    StickyHeaderView(
                        title: nil,
                        leadingComponent: nil,
                        trailingComponent: AnyView(
                            Button {
                                router.popToRoot()
                                router.navigateTo(.stressReliefEntry)
                            } label: {
                                Image("close")
                                    .frame(width:24, height:24)
                                    .foregroundColor(.grey500)
                            }
                        ),
                        backgroundColor: .clear
                    )
                    .frame(height:44)
                    Spacer()
                }
                .padding(.top, geo.safeAreaInsets.top)
                .frame(maxWidth:.infinity,
                       maxHeight:.infinity,
                       alignment:.top)
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

struct CloudGardenJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        CloudGardenJourneyView()
            .environmentObject(RouterModel())
    }
}
