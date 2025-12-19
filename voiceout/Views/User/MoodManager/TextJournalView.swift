//
//  TextJournalView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/11/25.
//

import SwiftUI

struct TextJournalView: View {
    @State var diaries: [DiaryEntry]
    @State private var currentStep: Int
    
    init(diaries: [DiaryEntry], onBack: @escaping () -> Void = {}) {
        _diaries = State(initialValue: diaries)
        _currentStep = State(initialValue: 0)
        self.onBack = onBack
    }
    
    var onBack: () -> Void
    @EnvironmentObject var router: RouterModel
    
    private let verticalPadding: CGFloat = ViewSpacing.medium
    private let totalSpacing: CGFloat = 8 * ViewSpacing.betweenSmallAndBase
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2.ignoresSafeArea()
            
            StickyHeaderView(
                title: "mood_diary_title",
                leadingComponent: AnyView(
                    BackButtonView(action: { onBack() })
                        .foregroundColor(.grey500)
                ),
                trailingComponent: AnyView(){},
                backgroundColor: Color.surfacePrimaryGrey2
            )
            .frame(maxWidth: .infinity, minHeight: 44)
            
            VStack(spacing: ViewSpacing.medium) {
                
                Spacer()
                    .frame(height: 44)
                
                if diaries.isEmpty {
                    Text(LocalizedStringKey("no_records"))
                        .foregroundColor(.textSecondary)
                } else {
                    let entry = diaries[safe: currentStep] ?? diaries[0]
                    let dateString = formatDate(entry.dateTime)
                    let moodKey = entry.mood.lowercased()
                    let moodLocalKey = moodImageToChinese[moodKey] ?? entry.mood
                    
                    Button(action: {
                        router.navigateTo(.textJournalDetail(entry: entry))
                    }) {
                        CardView(content: {
                            VStack(alignment: .center, spacing: ViewSpacing.small) {
                                Text(dateString)
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textLight)
                                    .multilineTextAlignment(.center)
                                VStack(alignment: .center, spacing: ViewSpacing.medium) {
                                    Image(moodKey)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 168, height: 120, alignment: .center)
                                        .padding(.vertical, ViewSpacing.medium)
                                        .imageShadow()
                                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                        HStack(alignment: .center, spacing: ViewSpacing.xsmall) {
                                            Text(LocalizedStringKey("i_feel"))
                                                .font(Font.typography(.bodyMedium))
                                                .foregroundColor(.textPrimary)
                                            let moodText = moodImageToChinese[moodKey] ?? entry.mood
                                            let intensityText = intensityDescription(entry.intensity ?? 0)
                                            Text("\(intensityText)\(moodText)")
                                                .font(Font.typography(.bodyMedium))
                                                .foregroundColor(.textBrandPrimary)
                                        }
                                        HStack(alignment: .center, spacing: ViewSpacing.xsmall) {
                                            Text(LocalizedStringKey("keywords"))
                                                .font(Font.typography(.bodyMedium))
                                                .foregroundColor(.textPrimary)
                                                .frame(width: 48, alignment: .topLeading)
                                            HStack(alignment: .center, spacing: ViewSpacing.small) {
                                                if let relation = entry.relation { TagView(text: relation) }
                                                if let location = entry.location { TagView(text: location) }
                                                if let reason = entry.reason { TagView(text: reason) }
                                            }
                                        }
                                        Text(entry.story.isEmpty ? "暂无记录" : entry.story)
                                            .font(Font.typography(.bodySmall))
                                            .foregroundColor(.textSecondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, 2 * ViewSpacing.betweenSmallAndBase)
                        }, modifiers: journalCardModifiers)
                        .frame(height: 400)
                    }
                }
                
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(alignment: .top, spacing: ViewSpacing.base) {
                            VStack(spacing: 0) {
                                ForEach(diaries.indices, id: \.self) { index in
                                    if index > 0 {
                                        Rectangle()
                                            .frame(width: 1, height: totalSpacing + ViewSpacing.base)
                                            .foregroundColor(.brandPrimary)
                                    }
                                    ZStack {
                                        Circle()
                                            .stroke(Color.brandPrimary, lineWidth: StrokeWidth.width100.value)
                                            .frame(width: 11, height: 11)
                                        
                                        if currentStep == index {
                                            Circle()
                                                .fill(Color.surfaceBrandPrimary)
                                                .frame(width: 11, height: 11)
                                            
                                            Circle()
                                                .stroke(Color.brandPrimary, lineWidth: StrokeWidth.width100.value)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }
                            }
                            .padding(.leading, ViewSpacing.large)
                            .offset(y: ViewSpacing.medium + ViewSpacing.large)
                            
                            VStack(spacing: verticalPadding) {
                                ForEach(diaries.indices, id: \.self) { index in
                                    let entry = diaries[index]
                                    
                                    EmotionCard(
                                        time: formatTime(entry.dateTime),
                                        emotion: moodImageToChinese[entry.mood.lowercased()] ?? entry.mood,
                                        image: entry.mood.lowercased(),
                                        intensity: entry.intensity ?? 0,
                                        isSelected: (currentStep == index)
                                    )
                                    .id(index)
                                    .onTapGesture {
                                        withAnimation {
                                            currentStep = index
                                            scrollProxy.scrollTo(index, anchor: .center)
                                        }
                                    }
                                    .frame(height: 92)
                                }
                            }
                        }
                        .padding(.bottom, ViewSpacing.medium)
                    }
                    .padding(.bottom, ViewSpacing.xxsmall)
                }
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct EmotionCard: View {
    var time: String
    var emotion: String
    var image: String
    var intensity: Double
    var isSelected: Bool
    
    var body: some View {
        CardView(content: {
            VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        Text(time)
                            .foregroundColor(isSelected ? .textInvert : .textSecondary)
                        
                        HStack(alignment: .center, spacing: ViewSpacing.medium) {
                            Text(LocalizedStringKey("i_feel")) +
                            Text(intensityDescription(intensity)) +
                            Text(emotion)
                        }
                        .foregroundColor(isSelected ? .textInvert : .textBrandPrimary)
                    }
                    .font(Font.typography(.bodyMedium))
                    
                    Spacer()
                    
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 60)
                        .imageShadow()
                }
            }
        }, modifiers: isSelected ? selectedEmotionCardModifiers : emotionCardModifiers)
    }
}

struct TagView: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: ViewSpacing.small) {
            Text(LocalizedStringKey(text))
                .font(Font.typography(.bodyXSmall))
                .foregroundColor(.textTitle)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .background(Color.surfaceBrandPrimary.opacity(0.4))
        .cornerRadius(CornerRadius.xsmall.value)
    }
}

private let journalCardModifiers = CardModifiers(
    padding: EdgeInsets(top: 2 * ViewSpacing.betweenSmallAndBase, leading: ViewSpacing.medium, bottom: 2 * ViewSpacing.betweenSmallAndBase, trailing: ViewSpacing.medium),
    backgroundColor: Color.grey50,
    cornerRadius: CornerRadius.medium.value,
    shadow1Color: Color.black.opacity(0.04),
    shadow1Radius: 10,
    shadow1X: 2,
    shadow1Y: 12,
    shadow2Color: Color.clear,
    shadow2Radius: 0,
    shadow2X: 0,
    shadow2Y: 0
)

private let emotionCardModifiers = CardModifiers(
    padding: EdgeInsets(top: ViewSpacing.medium, leading: ViewSpacing.medium, bottom: ViewSpacing.medium, trailing: ViewSpacing.medium),
    backgroundColor: Color.surfaceBrandTertiaryGreen,
    cornerRadius: CornerRadius.medium.value,
    shadow1Color: Color.black.opacity(0.03),
    shadow1Radius: 8.95,
    shadow1X: 5,
    shadow1Y: 3,
    shadow2Color: Color.black.opacity(0.08),
    shadow2Radius: 5.75,
    shadow2X: 2,
    shadow2Y: 4
)

private let selectedEmotionCardModifiers = CardModifiers(
    padding: EdgeInsets(top: ViewSpacing.medium, leading: ViewSpacing.medium, bottom: ViewSpacing.medium, trailing: ViewSpacing.medium),
    backgroundColor: Color.surfaceBrandPrimary,
    cornerRadius: CornerRadius.medium.value,
    shadow1Color: Color.black.opacity(0.03),
    shadow1Radius: 8.95,
    shadow1X: 5,
    shadow1Y: 3,
    shadow2Color: Color.black.opacity(0.08),
    shadow2Radius: 5.75,
    shadow2X: 2,
    shadow2Y: 4
)

#Preview {
    TextJournalView(
        diaries: [
            DiaryEntry(
                id: nil,
                userId: "user00123",
                timestamp: Date(),
                moodType: "Guilt",
                keyword: [],
                intensity: 0.5,
                location: "网上",
                persons: ["陌生人"],
                reasons: ["争吵"],
                diaryText: "今天和朋友发生了误会，感到难受。",
                selectedImage: "angry",
                attachments: nil
            ),
            DiaryEntry(
                id: nil,
                userId: "user00123",
                timestamp: Date().addingTimeInterval(-3600),
                moodType: "Happy",
                keyword: [],
                intensity: 0.5,
                location: "家里",
                persons: ["朋友"],
                reasons: ["聚会"],
                diaryText: "今天玩得很开心！",
                selectedImage: "happy",
                attachments: nil
            )
        ],
        onBack: {}
    )
}
