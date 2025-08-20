//
//  TextJournalDetailView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/18/25.
//

import SwiftUI
import AVKit

struct TextJournalDetailView: View {
    let diary: DiaryEntry
    @EnvironmentObject var router: RouterModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAudioVisible = true
    
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
                        .frame(width: 168, height: 120)
                        .padding(.vertical, ViewSpacing.medium)
                        .imageShadow()
                    
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
                
                ScrollView {
                    VStack(spacing: ViewSpacing.large) {
                        if let voiceUrlString = diary.attachments?.voiceUrl,
                           !voiceUrlString.isEmpty {
                            let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let voiceFileUrl = docsDir.appendingPathComponent(voiceUrlString)
                            
                            if FileManager.default.fileExists(atPath: voiceFileUrl.path) {
                                AudioPlaybackView(
                                    voiceUrl: voiceFileUrl.absoluteString,
                                    localFileUrl: voiceFileUrl,
                                    isVisible: $isAudioVisible
                                )
                            } else {
                                Text("The audio file cannot be played")
                                    .foregroundColor(.gray)
                                    .onAppear {
                                        print("The audio file does not exist: \(voiceFileUrl.path)")
                                    }
                            }
                        }

                        if let imagePaths = diary.attachments?.imageUrls {
                            let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let fullPaths = imagePaths.map { path in
                                path.hasPrefix("/") ? path : docsDir.appendingPathComponent(path).path
                            }

                            LazyVStack(spacing: ViewSpacing.small) {
                                ForEach(fullPaths, id: \.self) { fullPath in
                                    let exists = FileManager.default.fileExists(atPath: fullPath)
                                    let image = UIImage(contentsOfFile: fullPath)

                                    Group {
                                        if exists, let image = image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 188)
                                                .clipped()
                                                .onAppear {
                                                    print("The picture was loaded successfully.: \(fullPath)")
                                                }
                                        } else {
                                            Text("The picture cannot be loaded.")
                                                .frame(height: 188)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray)
                                                .padding(.horizontal, ViewSpacing.xlarge)
                                                .onAppear {
                                                    print("The image loading failed.: \(fullPath)")
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.top, ViewSpacing.medium)
                            .padding(.horizontal, ViewSpacing.small)
                            .imageShadow()
                        }
                    }

                    Spacer()
                }
                .padding(.bottom, ViewSpacing.large)
            }
            .padding(.horizontal, ViewSpacing.xlarge)
            .padding(.vertical, 2 * ViewSpacing.betweenSmallAndBase)
        }
        .navigationBarTitle(LocalizedStringKey("mood_diary_title"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image("left-arrow")
                .foregroundColor(.grey500)
        })
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
