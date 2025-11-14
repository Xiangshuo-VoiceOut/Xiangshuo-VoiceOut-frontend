//
//  CloudAudioOnboardingView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/23/25.
//

import SwiftUI
import AVFoundation

struct CloudAudioOnboardingView: View {
    @EnvironmentObject var router: RouterModel
    @Environment(\.presentationMode) var presentationMode
    
    private let startIndex: Int
    private let showSkip: Bool
    @State private var current: Int
    
    private let pages: [LocalizedStringKey] = [
        "audio_onboarding_welcome",
        "audio_onboarding_intro",
        "audio_onboarding_anxiety_peace",
        "audio_onboarding_touch_sounds",
        "audio_onboarding_close_eyes"
    ]
    
    @State private var isFarewell = false
    
    private let farewellPages: [LocalizedStringKey] = [
        "audio_onboarding_farewell_1",
        "audio_onboarding_farewell_2",
        "audio_onboarding_farewell_3"
    ]
    
    private var activePages: [LocalizedStringKey] { isFarewell ? farewellPages : pages }
    
    @State private var showPicker = false
    @State private var instrumentIndex = 0
    @State private var bubbleText: LocalizedStringKey = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var workItem: DispatchWorkItem?
    
    private let instrumentIds: [String] = [
        "handdrum",
        "rainstick",
        "djembe",
        "tonebar",
        "kalimba",
        "singingbowl"
    ]
    
    private let bgNames: [String] = [
        "handdrumcard-background",
        "rainstickcard-background",
        "djembecard-background",
        "tonebarcard-background",
        "kalimbacard-background",
        "singingbowlcard-background"
    ]
    
    private let titles: [LocalizedStringKey] = [
        "instrument_title_handdrum",
        "instrument_title_rainstick",
        "instrument_title_djembe",
        "instrument_title_tonebar",
        "instrument_title_kalimba",
        "instrument_title_singingbowl"
    ]
    
    private let backgroundNames: [String] = [
        "handdrum-background",
        "rainstick-background",
        "djembe-background",
        "tonebar-background",
        "kalimba-background",
        "singingbowl-background"
    ]
    
    init(startIndex: Int = 0, showSkip: Bool = false) {
        self.startIndex = startIndex
        self.showSkip = showSkip
        self._current = State(initialValue: startIndex)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let bgImageName = showPicker
                ? (backgroundNames[safe: instrumentIndex] ?? "audioonboarding-background")
                : "audioonboarding-background"
                
                Image(bgImageName)
                    .resizable()
                
                if current >= pages.count && !isFarewell {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                stops: [
                                    .init(color: Color(red: 0.42, green: 0.65, blue: 0.94).opacity(0), location: 0),
                                    .init(color: Color(red: 0.14, green: 0.21, blue: 0.30).opacity(0.4), location: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    StickyHeaderView(
                        title: String(localized: "cloud_audio"),
                        leadingComponent: AnyView(Spacer().frame(width: 24)),
                        trailingComponent: AnyView(
                            Button {
                                router.popToRoot()
                                router.navigateTo(.stressReliefEntry)
                            } label: {
                                Image("close")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.grey500)
                            }
                        ),
                        backgroundColor: .clear
                    )
                    .padding(.top, geo.safeAreaInsets.top)
                    .frame(maxWidth: .infinity)
                    
                    if showSkip && !showPicker && current < activePages.count - 1 {
                        HStack {
                            Spacer()
                            Button("skip") {
                                withAnimation {
                                    current = activePages.count - 1
                                }
                            }
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(.brandTertiaryGreen)
                            .padding(.trailing, ViewSpacing.medium)
                        }
                        .padding(.top, ViewSpacing.small)
                    }
                    
                    if !showPicker && current < activePages.count {
                        Text(activePages[current])
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 2*ViewSpacing.xlarge)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    if current < activePages.count - 1 {
                                        current += 1
                                    } else {
                                        if isFarewell {
                                            presentationMode.wrappedValue.dismiss()
                                        } else {
                                            current = activePages.count
                                        }
                                    }
                                }
                            }
                    } else if !showPicker && !isFarewell {
                        ZStack(alignment: .bottomTrailing) {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white.opacity(0.4))
                                .frame(width: 326, height: 108)
                                .offset(
                                    x: ViewSpacing.xxxsmall + ViewSpacing.xxsmall,
                                    y: ViewSpacing.small
                                )
                            
                            Image("polygon4")
                                .frame(width: 29, height: 29)
                                .offset(
                                    x: -5 * ViewSpacing.base,
                                    y: ViewSpacing.xxsmall + ViewSpacing.large
                                )
                                .opacity(0.4)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(LocalizedStringKey("audio_onboarding_pick_instrument"))
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: 326 - 28, alignment: .leading)
                                    .padding(.horizontal, ViewSpacing.xsmall+ViewSpacing.large)
                            }
                            .frame(width: 326, height: 108)
                            .background(Color.white)
                            .cornerRadius(28)
                        }
                        .padding(.leading, ViewSpacing.medium)
                        .padding(.trailing, 2*ViewSpacing.large)
                        .padding(.top, ViewSpacing.xsmall+ViewSpacing.xlarge)
                        
                        Image("polygon4")
                            .frame(width: 29, height: 29)
                            .offset(x: ViewSpacing.base+2*ViewSpacing.xlarge, y: -ViewSpacing.small)
                        
                        Image("calm")
                            .padding(.horizontal, ViewSpacing.xxxsmall)
                            .padding(.vertical, ViewSpacing.xxsmall+ViewSpacing.medium)
                            .frame(width: 200, height: 144, alignment: .center)
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
                        
                        Button(LocalizedStringKey("audio_onboarding_start_explore")) {
                            withAnimation {
                                showPicker = true
                                schedulePlayback(for: 0)
                            }
                        }
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textLight)
                        .padding(.top, ViewSpacing.large)
                        
                        Spacer()
                        
                    } else {
                        ZStack(alignment: .bottomTrailing) {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white.opacity(0.4))
                                .frame(width: 326, height: 108)
                                .offset(
                                    x: ViewSpacing.xxxsmall + ViewSpacing.xxsmall,
                                    y: ViewSpacing.small
                                )
                            Image("polygon4")
                                .frame(width: 29, height: 29)
                                .offset(
                                    x: -5 * ViewSpacing.base,
                                    y: ViewSpacing.xxsmall + ViewSpacing.large
                                )
                                .opacity(0.4)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(bubbleText)
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: 326 - 28, alignment: .leading)
                                    .padding(.horizontal, ViewSpacing.xsmall+ViewSpacing.large)
                            }
                            .frame(width: 326, height: 108)
                            .background(Color.white)
                            .cornerRadius(28)
                        }
                        .padding(.leading, ViewSpacing.medium)
                        .padding(.trailing, 2*ViewSpacing.large)
                        .padding(.top, ViewSpacing.xsmall+ViewSpacing.xlarge)
                        
                        Image("polygon4")
                            .frame(width: 29, height: 29)
                            .offset(x: ViewSpacing.base+2*ViewSpacing.xlarge, y: -ViewSpacing.small)
                        
                        Image("calm")
                            .padding(.horizontal, ViewSpacing.xxxsmall)
                            .padding(.vertical, ViewSpacing.xxsmall+ViewSpacing.medium)
                            .frame(width: 200, height: 144, alignment: .center)
                            .scaleEffect(x: -1, y: 1)
                        
                        Image("cloud-shadow")
                            .renderingMode(.template)
                            .foregroundColor(Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.55))
                            .frame(width: 94.5, height: 16.1)
                        
                        CarouselTabView(
                            instrumentIndex: $instrumentIndex,
                            bgNames: bgNames,
                            instrumentIds: instrumentIds,
                            titles: titles
                        )
                        .onChange(of: instrumentIndex) { newValue in
                            schedulePlayback(for: newValue)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isFarewell = true
                                showPicker  = false
                                current     = 0
                            }
                        } label: {
                            Text(LocalizedStringKey("audio_onboarding_end_explore"))
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.vertical, ViewSpacing.small)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .padding(.bottom, 2*ViewSpacing.large)
                        .ignoresSafeArea(edges: .bottom)
                    }
                }
            }
            .onChange(of: showPicker) { on in
                if on {
                    StressReliefBGMManager.shared.fadeOutAndPause(duration: 0.4)
                    schedulePlayback(for: instrumentIndex)
                } else {
                    stopSound()
                    workItem?.cancel()
                }
            }
            .onChange(of: isFarewell) { nowFarewell in
                if nowFarewell {
                    StressReliefBGMManager.shared.fadeInAndResume(duration: 0.4)
                }
            }
            .onAppear {
                prepareAudioSession()
            }
            .onDisappear {
                stopSound()
                workItem?.cancel()
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
    
    private func schedulePlayback(for idx: Int) {
        workItem?.cancel()
        stopSound()
        bubbleText = bubbleTextText(for: idx)
        
        let item = DispatchWorkItem { [weak audioPlayer] in
            if self.instrumentIndex == idx && self.showPicker {
                self.playSound(for: idx)
            }
        }
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
    }
    
    private func playSound(for idx: Int) {
        prepareAudioSession()
        let name = instrumentIds[idx]
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Missing audio file: \(name).mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = 0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play \(name): \(error)")
        }
    }
    
    private func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    private func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    private func bubbleTextText(for idx: Int) -> LocalizedStringKey {
        switch idx {
        case 0: return "instrument_desc_handdrum"
        case 1: return "instrument_desc_rainstick"
        case 2: return "instrument_desc_djembe"
        case 3: return "instrument_desc_tonebar"
        case 4: return "instrument_desc_kalimba"
        case 5: return "instrument_desc_singingbowl"
        default: return ""
        }
    }
}

private struct CarouselTabView: View {
    @Binding var instrumentIndex: Int
    let bgNames: [String]
    let instrumentIds: [String]
    let titles: [LocalizedStringKey]

    private let spacing: CGFloat = 36
    private let aspect: CGFloat = 241.2 / 160.8
    private let sideScale: CGFloat = 134.0 / 160.8
    private let minCenterW: CGFloat = 150

    @State private var scrollID: Int? = 0

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let designCenterW: CGFloat = 160.8
            let Craw = W * 0.5 - spacing
            let C = max(0, W * 0.5 - spacing)
            let H = C * aspect
            let margin = (W - C) / 2
            let focused = scrollID ?? instrumentIndex

            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach(bgNames.indices, id: \.self) { idx in
                        let isCenter = (idx == focused)
                        let contentScale: CGFloat = isCenter ? 1.0 : sideScale

                        InstrumentCarouselCard(
                            bgName: bgNames[idx],
                            instrumentId: instrumentIds[idx],
                            title: titles[idx],
                            containerW: C,
                            containerH: H,
                            contentScale: contentScale,
                            isCenter: isCenter
                        )
                        .frame(width: C, height: H)
                        .id(idx)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, margin, for: .scrollContent)
            .scrollPosition(id: $scrollID, anchor: .center)
            .onAppear { scrollID = instrumentIndex }
            .onChange(of: instrumentIndex) { newValue in
                if scrollID != newValue { scrollID = newValue }
            }
            .onChange(of: scrollID) { newID in
                if let newID, newID != instrumentIndex {
                    instrumentIndex = newID
                }
            }
            .frame(height: H)
            .gesture(
                DragGesture(minimumDistance: 3, coordinateSpace: .local)
                    .onEnded { value in
                        let threshold = C * 0.25 + spacing * 0.5
                        var target = instrumentIndex
                        if value.translation.width <= -threshold {
                            target = min(instrumentIndex + 1, bgNames.count - 1)
                        } else if value.translation.width >= threshold {
                            target = max(instrumentIndex - 1, 0)
                        }
                        withAnimation(.snappy) { scrollID = target }
                    }
            )
        }
        .frame(height: 1)
    }
}

private struct InstrumentCarouselCard: View {
    let bgName: String
    let instrumentId: String
    let title: LocalizedStringKey
    let containerW: CGFloat
    let containerH: CGFloat
    let contentScale: CGFloat
    let isCenter: Bool
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                Image(bgName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: containerW, height: containerH)
                    .clipped()
                
                VStack(spacing: containerH * 0.06) {
                    Image(instrumentId)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: containerW * 0.8, height: containerH * 0.7)
                        .offset(y: -containerH * 0.02)
                    
                    Text(title)
                        .font(Font.typography(.bodyLargeEmphasis))
                        .foregroundColor(.brandTertiaryGreen)
                        .padding(.bottom, ViewSpacing.base)
                }
                .frame(width: containerW, height: containerH, alignment: .bottom)
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                    .stroke(Color.white, lineWidth: StrokeWidth.width100.value)
                
            )
            .scaleEffect(contentScale, anchor: .center)
            .animation(.easeInOut(duration: 0.2), value: contentScale)
        }
        .frame(width: containerW, height: containerH)
        .contentShape(Rectangle())
    }
}

struct CloudAudioOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        CloudAudioOnboardingView(startIndex: 0, showSkip: false)
            .environmentObject(RouterModel())
    }
}
