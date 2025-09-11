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
                        if let voicePath = diary.attachments?.voiceUrl, !voicePath.isEmpty {
                            let remoteURL = resolveRemoteURL(from: voicePath)
                            let localURL  = resolveLocalURL(fromServerPathOrName: voicePath)

                            if remoteURL == nil && localURL == nil {
                                Text("The audio file cannot be played")
                                    .foregroundColor(.gray)
                                    .onAppear { print("Audio not found remotely or locally: \(voicePath)") }
                            } else {
                                AudioPlaybackView(
                                    voiceUrl: (remoteURL ?? localURL)?.absoluteString ?? "",
                                    localFileUrl: localURL,
                                    isVisible: $isAudioVisible
                                )
                                .onAppear {
                                    print("Audio prepared. remote=\(remoteURL?.absoluteString ?? "nil"), local=\(localURL?.path ?? "nil")")
                                }
                            }
                        }

                        if let imagePaths = diary.attachments?.imageUrls, !imagePaths.isEmpty {
                            LazyVStack(spacing: ViewSpacing.small) {
                                ForEach(imagePaths, id: \.self) { one in
                                    RemoteImageWithLocalFallback(pathOrURL: one)
                                        .frame(height: 188)
                                        .padding(.horizontal, ViewSpacing.xlarge)
                                        .imageShadow()
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
    
    private func resolveRemoteURL(from pathOrURL: String) -> URL? {
        if pathOrURL.lowercased().hasPrefix("http://") || pathOrURL.lowercased().hasPrefix("https://") {
            return URL(string: pathOrURL)
        }
        if pathOrURL.hasPrefix("/") {
            return URL(string: API.host + pathOrURL)
        }
        return nil
    }

    private func resolveLocalURL(fromServerPathOrName s: String) -> URL? {
        let name: String
        if let url = URL(string: s), url.scheme != nil {
            name = url.lastPathComponent
        } else {
            name = (s as NSString).lastPathComponent
        }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let local = docs.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: local.path) ? local : nil
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

private struct RemoteImageWithLocalFallback: View {
    let pathOrURL: String

    private func remoteURL() -> URL? {
        if pathOrURL.lowercased().hasPrefix("http://") || pathOrURL.lowercased().hasPrefix("https://") {
            return URL(string: pathOrURL)
        }
        if pathOrURL.hasPrefix("/") {
            return URL(string: API.host + pathOrURL)
        }
        return nil
    }

    private func localImage() -> UIImage? {
        let name: String
        if let url = URL(string: pathOrURL), url.scheme != nil {
            name = url.lastPathComponent
        } else {
            name = (pathOrURL as NSString).lastPathComponent
        }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let local = docs.appendingPathComponent(name)
        return UIImage(contentsOfFile: local.path)
    }

    var body: some View {
        if let url = remoteURL() {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle().fill(Color.gray.opacity(0.2)).overlay(ProgressView())
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill).clipped()
                        .onAppear { print("Remote image loaded: \(url.absoluteString)") }
                case .failure:
                    if let ui = localImage() {
                        Image(uiImage: ui).resizable().aspectRatio(contentMode: .fill).clipped()
                            .onAppear { print("Fallback local image loaded") }
                    } else {
                        Rectangle().fill(Color.gray)
                            .overlay(Text("The picture cannot be loaded."))
                            .onAppear { print("Image failed both remote and local: \(pathOrURL)") }
                    }
                @unknown default:
                    Rectangle().fill(Color.gray)
                }
            }
        } else if let ui = localImage() {
            Image(uiImage: ui).resizable().aspectRatio(contentMode: .fill).clipped()
                .onAppear { print("Local image loaded (no remote url)") }
        } else {
            Rectangle().fill(Color.gray).overlay(Text("The picture cannot be loaded."))
                .onAppear { print("No remote url, local not found: \(pathOrURL)") }
        }
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
