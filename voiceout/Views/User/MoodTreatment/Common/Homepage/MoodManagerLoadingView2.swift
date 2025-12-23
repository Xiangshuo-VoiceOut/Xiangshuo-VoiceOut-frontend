//
//  MoodManagerLoadingView2.swift
//  voiceout
//
//  Created by Yujia Yang on 3/6/25.
//

import SwiftUI

struct MoodManagerLoadingView2: View {
    @EnvironmentObject var router: RouterModel
    @State private var selectedImage: String = "happy"
    @State private var texts: [String] = ["转动转盘，告诉小云朵你的心情吧！"]
    @State private var displayedCount: Int = 1
    @State private var bubbleHeight: CGFloat = 0
    private var bubbleFrameHeight: CGFloat { max(bubbleHeight, 88) }

    @State private var isSaving = false

    private var isComingSoonMood: Bool {
        let mood = selectedImage.lowercased()
        return ["happy", "calm", "angry", "envy"].contains(mood)
    }
    private var confirmButtonTitle: String {
        isComingSoonMood ? "敬请期待" : "确定"
    }
    private var confirmButtonFont: Font {
        isComingSoonMood ? Font.typography(.bodySmall) : Font.typography(.bodyMedium)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.surfaceBrandTertiaryBlue.ignoresSafeArea()
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "疗愈云港",
                    leadingComponent: AnyView(Spacer().frame(width: ViewSpacing.large)),
                    trailingComponent: AnyView(
                        Button(action: { router.navigateTo(.mainHomepage) }) {
                            Image("close")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.grey500)
                        }
                    ),
                    backgroundColor: Color.surfaceBrandTertiaryBlue
                )
                .frame(maxWidth: .infinity, minHeight: 44)
                
                VStack {
                    HStack(alignment: .bottom, spacing: 0) {
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 71)
                            .scaleEffect(x: -1, y: 1)
                            .offset(x: -ViewSpacing.medium)
                            .frame(width: 68)
                        
                        BubbleScrollView(
                            texts: texts,
                            displayedCount: $displayedCount,
                            bubbleHeight: $bubbleHeight,
                            bubbleSpacing: ViewSpacing.large,
                            totalHeight: bubbleFrameHeight
                        )
                        .foregroundColor(.grey500)
                        .safeImageShadow()
                        .environment(\.font, Font.typography(.bodyMedium))
                        
                        Spacer()
                    }
                }
                
                ZStack {
                    RotatingWheelView2(selectedImage: $selectedImage)
                }
                
                let isButtonDisabled = isSaving || isComingSoonMood
                let titleColor: Color = isButtonDisabled ? .textLight : .textBrandPrimary
                Button(action: submitMoodAndGo) {
                    ZStack {
                        Circle()
                            .fill(Color.surfacePrimary)
                            .frame(width: 72, height: 72)
                            .safeImageShadow()
                        VStack(spacing: 0) {
                            Image(isButtonDisabled ? "arrow-right-gray" : "arrow-right")
                                .frame(width: 24, height: 24)
                            Text(confirmButtonTitle)
                                .font(confirmButtonFont)
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(titleColor)
                        }
                    }
                    .overlay(Circle().stroke(Color.grey50, lineWidth: StrokeWidth.width200.value))
                }
                .padding(.bottom, ViewSpacing.medium)
                .frame(width: 72, height: 72)
                .disabled(isButtonDisabled)
                .opacity(isSaving ? 0.6 : 1.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func submitMoodAndGo() {
        guard !isSaving else { return }
        isSaving = true

        let entry = DiaryEntry(
            id: nil,
            userId: "user00123",
            timestamp: Date(),
            moodType: selectedImage.lowercased(),
            keyword: [],
            intensity: 0.5,
            location: "",
            persons: [],
            reasons: [],
            diaryText: "",
            selectedImage: selectedImage,
            attachments: nil
        )

        MoodManagerService.shared.createDiaryEntry(entry: entry) { result in
            DispatchQueue.main.async {
                self.isSaving = false
                UserDefaults.standard.set(selectedImage.lowercased(), forKey: "last_selected_mood")

                switch result {
                case .success:
                    router.navigateTo(routeForMood(selectedImage))
                case .failure(let err):
                    router.navigateTo(routeForMood(selectedImage))
                }
            }
        }
    }

    private func routeForMood(_ mood: String) -> Route {
        switch mood.lowercased() {
        case "happy": return .moodTreatmentHappyHomepage
        case "sad": return .moodTreatmentSadHomepage
        case "angry": return .moodTreatmentAngryHomepage
        case "guilt": return .moodTreatmentGuiltHomepage
        case "envy": return .moodTreatmentEnvyHomepage
        case "scare": return .moodTreatmentScareHomepage
        case "anxiety": return .moodTreatmentAnxietyHomepage
        default: return .mainHomepage
        }
    }
}

private struct SafeImageShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
private extension View {
    func safeImageShadow() -> some View { modifier(SafeImageShadowModifier()) }
}

struct MoodManagerLoadingView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoodManagerLoadingView2()
                .environmentObject(RouterModel())
        }
    }
}
