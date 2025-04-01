//
//  TextJournalDetailView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/18/25.
//

import SwiftUI

struct TextJournalDetailView: View {
    let diary: DiaryEntry
    
    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: ViewSpacing.large) {
                Text(formatDate(diary.timestamp))
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textLight)
                
                VStack(alignment: .center, spacing: ViewSpacing.medium) {
                    Image(diary.moodType.lowercased())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168, height: 120, alignment: .center)
                        .padding(.vertical, ViewSpacing.medium)
                        .imageShadow()
                    
                    if let extraImageUrl = diary.attachments?.imageUrls?.first {
                        AsyncImage(url: URL(string: extraImageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 174, height: 86)
                        .cornerRadius(CornerRadius.small.value)
                        .shadow(radius: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        HStack(spacing: ViewSpacing.xsmall) {
                            Text(LocalizedStringKey("i_feel"))
                                .foregroundColor(.textPrimary)
                            
                            Text("\(intensityDescription(diary.intensity))\(moodImageToChinese[diary.moodType.lowercased()] ?? diary.moodType)")
                                .foregroundColor(.textBrandPrimary)
                        }
                        .font(Font.typography(.bodyMedium))
                        
                        HStack(spacing: ViewSpacing.xsmall) {
                            Text(LocalizedStringKey("keywords"))
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textPrimary)
                                .frame(width: 48, alignment: .topLeading)
                            
                            HStack(spacing: ViewSpacing.small) {
                                if let person = diary.persons?.first, !person.isEmpty {
                                    TagView(text: person)
                                }
                                if let location = diary.location, !location.isEmpty {
                                    TagView(text: location)
                                }
                                if let reason = diary.reasons?.first, !reason.isEmpty {
                                    TagView(text: reason)
                                }
                            }
                        }
                        
                        Text(diary.diaryText?.isEmpty == false ? diary.diaryText! : "暂无记录")
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, alignment: .top)
                
                HStack(alignment: .center, spacing: 0) {
                    Text(LocalizedStringKey("audio_file"))
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textBrandPrimary)
                        .frame(height: 60, alignment: .center)
                    
                    Spacer()
                    
                    Button(action: {
                        if let voiceUrl = diary.attachments?.voiceUrl, !voiceUrl.isEmpty {
                        } else {
                        }
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color.surfaceBrandPrimary)
                            Image("polygon")
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(ViewSpacing.medium)
                .background(Color.surfaceBrandTertiaryGreen)
                .cornerRadius(CornerRadius.medium.value)
                .padding(.horizontal,ViewSpacing.small)
                .imageShadow()
                
                ZStack {
                    Color.clear
                }
                .frame(height: 188)
                .background(Color(red: 0.84, green: 0.85, blue: 0.85))
                .padding(.horizontal,ViewSpacing.small)
                .imageShadow()
                
                Spacer()
            }
            .padding(.horizontal, ViewSpacing.xlarge)
            .padding(.vertical, 2 * ViewSpacing.betweenSmallAndBase)
        }
        .navigationBarTitle(LocalizedStringKey("mood_diary_title"), displayMode: .inline)
        .navigationBarBackButtonHidden(false)
        .accentColor(.grey500)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    TextJournalDetailView(
        diary: DiaryEntry(
            id: nil,
            userId: "user00123",
            timestamp: Date(),
            moodType: "Happy",
            keyword: [],
            intensity: 0.5,
            location: "网上",
            persons: ["陌生人"],
            reasons: ["争吵"],
            diaryText: "我因为和陌生人在网上发生争执感到生气，不知道该怎么办.",
            selectedImage: "angry",
            attachments: nil
        )
    )
}
