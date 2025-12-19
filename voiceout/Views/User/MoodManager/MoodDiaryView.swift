//
//  MoodDiaryView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/6/25.
//

import SwiftUI
import UIKit

enum MoodDiaryContent {
    case diary
    case voiceRecorder
    case selectPicture
    case customPhotoPicker
}

struct MoodDiaryView: View {
    @State private var emotionIntensity: Double = 0.5
    @State private var selectedLocation: String = ""
    @State private var selectedRelation: String = ""
    @State private var selectedReason: String = ""
    @State private var storyText: String = ""
    @State private var content: MoodDiaryContent = .diary
    @State private var selectedImages: [UIImage] = []
    @State private var isPhotoPickerPresented: Bool = false
    @State private var diaries: [DiaryEntry] = []
    @State private var showExitPopup = false
    @State private var customLocations: [String] = []
    @State private var customRelations: [String] = []
    @State private var customReasons: [String] = []
    @State private var showAddLocationSheet = false
    @State private var showAddRelationSheet = false
    @State private var showAddReasonSheet = false
    let selectedImage: String
    @State private var voiceUrl: String = ""
    @State private var uploadedImagePaths: [String] = []
    @State private var isUploadingImages = false
    @State private var imageUploadError: String?
    @State private var showImageUploadError = false
    @EnvironmentObject var router: RouterModel
    
    private let defaultLocations = [
        "location_home",
        "location_restaurant",
        "location_street",
        "location_office",
        "location_school",
        "location_online"
    ]
    private let defaultRelations = [
        "relation_colleague",
        "relation_family",
        "relation_classmate",
        "relation_stranger",
        "relation_self",
        "relation_friend"
    ]
    private let defaultReasons = [
        "reason_ignored",
        "reason_stress",
        "reason_misunderstanding",
        "reason_argument",
        "reason_trivial",
        "reason_criticized"
    ]
    
    private var allLocations: [String] {
        defaultLocations + customLocations + ["+"]
    }
    private var allRelations: [String] {
        defaultRelations + customRelations + ["+"]
    }
    private var allReasons: [String] {
        defaultReasons + customReasons + ["+"]
    }

    private var diaryHeader: some View {
        StickyHeaderView(
            title: "mood_diary_title",
            leadingComponent: AnyView(
                BackButtonView(action: {
                    switch content {
                    case .voiceRecorder:
                        content = .diary
                    case .customPhotoPicker:
                        content = .selectPicture
                    case .selectPicture:
                        uploadSelectedImagesThenBack()
                    case .diary:
                        router.navigateBack()
                    }
                })
                .foregroundColor(.grey500)
            ),
            trailingComponent: AnyView(
                Group {
                    if !(content == .voiceRecorder || content == .selectPicture || content == .customPhotoPicker) {
                        Button(action: {
                            showExitPopup = true
                        }) {
                            Image("close")
                                .foregroundColor(.grey500)
                        }
                    } else {
                        Color.clear.frame(width: 44, height: 44)
                    }
                }
            ),
            backgroundColor: Color.surfacePrimaryGrey2
        )
    }
    
    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2.ignoresSafeArea()
            VStack(spacing: 0) {
                diaryHeader
                switch content {
                    
                case .diary:
                    diaryContentView
                    
                case .voiceRecorder:
                    MoodManagerVoiceView(
                        showVoiceRecorder: Binding(
                            get: { content == .voiceRecorder },
                            set: { isActive in content = isActive ? .voiceRecorder : .diary }
                        ),
                        voiceUrl: $voiceUrl,
                        onBack: { content = .diary }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    
                case .selectPicture:
                    SelectPictureView(
                        selectedImages: $selectedImages,
                        onBack: { content = .diary},
                        onSend: { _ in},
                        onPhotoPicker: { content = .customPhotoPicker }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    
                case .customPhotoPicker:
                    CustomPhotoPickerView(
                        selectedImages: $selectedImages,
                        isPresented: $isPhotoPickerPresented,
                        onBack: {
                            isPhotoPickerPresented = false
                            content = .selectPicture
                        }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .overlay(
            Group {
                if showExitPopup {
                    ZStack {
                        Color.black.opacity(0.05)
                            .ignoresSafeArea()
                        
                        ExitMoodManagerView(
                            didClose: {
                                showExitPopup = false
                            },
                            didConfirm: {
                                showExitPopup = false
                                router.navigateTo(.moodManagerLoading)
                            }
                        )
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 4)
                    }
                    .transition(.opacity)
                }
            }
        )
        .sheet(isPresented: $showAddLocationSheet) {
            AddTagView(
                onCancel: {
                    showAddLocationSheet = false
                },
                onDone: { newTag in
                    if !newTag.isEmpty {
                        customLocations.insert(newTag, at: 0)
                    }
                    showAddLocationSheet = false
                }
            )
        }
        .sheet(isPresented: $showAddRelationSheet) {
            AddTagView(
                onCancel: {
                    showAddRelationSheet = false
                },
                onDone: { newTag in
                    if !newTag.isEmpty {
                        customRelations.insert(newTag, at: 0)
                    }
                    showAddRelationSheet = false
                }
            )
        }
        .sheet(isPresented: $showAddReasonSheet) {
            AddTagView(
                onCancel: {
                    showAddReasonSheet = false
                },
                onDone: { newTag in
                    if !newTag.isEmpty {
                        customReasons.insert(newTag, at: 0)
                    }
                    showAddReasonSheet = false
                }
            )
        }
        .alert("Upload failed", isPresented: $showImageUploadError, actions: {
            Button("OK") { imageUploadError = nil }
        }, message: {
            Text(imageUploadError ?? "Unknown error")
        })
    }
    
    private var diaryContentView: some View {
        ScrollView {
            Image(selectedImage)
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 124)
                .padding(.top, ViewSpacing.large+ViewSpacing.xxsmall)
                .imageShadow()
            
            VStack(spacing: ViewSpacing.large) {
                VStack(alignment: .leading, spacing: ViewSpacing.small) {
                    Text(LocalizedStringKey("mood_intensity_question"))
                        .font(Font.typography(.bodyMediumEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                    SliderView(
                        value: $emotionIntensity,
                        minValue: 0,
                        maxValue: 1,
                        trackColor: .surfaceBrandPrimary,
                        thumbInnerColor: .surfaceBrandPrimary,
                        thumbOuterColor: .surfacePrimaryGrey2,
                        thumbInnerDiameter: 12,
                        thumbOuterDiameter: 16
                    )
                    .frame(height: 6)
                    
                    HStack {
                        Text(LocalizedStringKey("intensity_low"))
                        
                        Spacer()
                        
                        Text(LocalizedStringKey("intensity_medium"))
                        
                        Spacer()
                        
                        Text(LocalizedStringKey("intensity_high"))
                    }
                    .font(Font.typography(.bodyXXSmall))
                    .foregroundColor(.textLight)
                }
                TagSelectionView(
                    title: String(localized: "tag_where"),
                    options: allLocations,
                    selectedTag: $selectedLocation
                ) {
                    showAddLocationSheet = true
                }
                TagSelectionView(
                    title: String(localized: "tag_relation"),
                    options: allRelations,
                    selectedTag: $selectedRelation
                ) {
                    showAddRelationSheet = true
                }
                TagSelectionView(
                    title: String(localized: "tag_reason"),
                    options: allReasons,
                    selectedTag: $selectedReason
                ) {
                    showAddReasonSheet = true
                }
            }
            .padding(.top, ViewSpacing.base+ViewSpacing.large)
            
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                HStack(alignment: .top, spacing: ViewSpacing.small) {
                    HStack(alignment: .bottom, spacing: ViewSpacing.small) {
                        Image("edit")
                            .foregroundColor(.grey200)
                            .frame(width: 24, height: 24)
                        TextField(LocalizedStringKey("story_placeholder"), text: $storyText)
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.grey200)
                    }
                    .cornerRadius(CornerRadius.medium.value)
                    
                    Spacer()
                    
                    Button(action: { content = .voiceRecorder }) {
                        ZStack {
                            Circle()
                                .fill(Color.surfacePrimaryGrey)
                                .frame(width: 44, height: 44)
                            Image("voice")
                                .frame(width: 15, height: 20)
                        }
                    }
                    Button(action: { content = .selectPicture }) {
                        ZStack {
                            Circle()
                                .fill(Color.surfacePrimaryGrey)
                                .frame(width: 44, height: 44)
                            Image("picture-one")
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(ViewSpacing.medium)
                .frame(maxWidth: .infinity)
                .background(Color.grey50)
                .cornerRadius(CornerRadius.medium.value)
            }
            .frame(maxWidth: .infinity)
            
            VStack{
                Button(action: {
                    let userId = "user00123"
                    let imagePaths = uploadedImagePaths
                    print("Current audio path voiceUrl: \(voiceUrl)")

                    let newDiary = DiaryEntry(
                        id: nil,
                        userId: userId,
                        timestamp: Date(),
                        moodType: selectedImage.lowercased(),
                        keyword: [],
                        intensity: emotionIntensity,
                        location: selectedLocation,
                        persons: selectedRelation.isEmpty ? [] : [selectedRelation],
                        reasons: selectedReason.isEmpty ? [] : [selectedReason],
                        diaryText: storyText,
                        selectedImage: selectedImage,
                        attachments: Attachments(
                            voiceUrl: voiceUrl.isEmpty ? nil : voiceUrl,
                            imageUrls: imagePaths
                        )
                    )
                    
                    MoodManagerService.shared.createDiaryEntry(entry: newDiary) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                print("The diary was saved successfully.")
                                print("Final voiceUrl saved in diary: \(voiceUrl)")
                                router.navigateTo(.moodHomepageLauncher)
                            case .failure(let error):
                                print("Diary save failed.: \(error.localizedDescription)")
                                self.imageUploadError = "Diary save failed: \(error.localizedDescription)"
                                self.showImageUploadError = true
                            }
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.surfacePrimary)
                            .frame(width: 72, height: 72)
                            .imageShadow()
                        VStack(spacing: 0) {
                            Image("arrow-right")
                                .frame(width: 24, height: 24)
                            Text(LocalizedStringKey("save"))
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textBrandPrimary)
                        }
                    }
                    .overlay(Circle().stroke(Color.grey50, lineWidth: StrokeWidth.width200.value))
                }
            }
            .padding(.top, ViewSpacing.small)
            .padding(.bottom, ViewSpacing.medium)
        }
        .padding(.horizontal, ViewSpacing.medium)
    }

    private func uploadSelectedImagesThenBack() {
        if selectedImages.isEmpty {
            content = .diary
            return
        }

        isUploadingImages = true
        imageUploadError = nil
        uploadedImagePaths.removeAll()

        let userId = "user123456"
        let format = "jpg"
        let serverBasePath = "/uploads"

        let group = DispatchGroup()
        var errors: [String] = []
        var results: [String] = []

        for (idx, img) in selectedImages.enumerated() {
            group.enter()
            MoodManagerImageUploader.uploadImageFile(
                img,
                userId: userId,
                format: format,
                serverBasePath: serverBasePath
            ) { result in
                switch result {
                case .success(let fullUrlOrPath):
                    print("[\(idx)] image saved:", fullUrlOrPath)
                    results.append(fullUrlOrPath)
                case .failure(let e):
                    print("[\(idx)] image failed:", e.localizedDescription)
                    errors.append(e.localizedDescription)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isUploadingImages = false
            if errors.isEmpty {
                self.uploadedImagePaths = results
                self.content = .diary
            } else {
                self.imageUploadError = errors.joined(separator: "\n")
                self.showImageUploadError = true
            }
        }
    }
}

struct TagSelectionView: View {
    let title: String
    let options: [String]
    @Binding var selectedTag: String
    
    var onPlusTapped: (() -> Void)? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            Text(title)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(options, id: \.self) { item in
                    ButtonView(
                        text: item,
                        action: {  if item == "+" {
                            onPlusTapped?()
                        } else {
                            selectedTag = item
                        }
                        },
                        variant: .solid,
                        theme: selectedTag == item ? .action : .bagdeInactive,
                        fontSize: .medium,
                        borderRadius: .full
                    )
                    .frame(height: 28)
                    .clipShape(Capsule())
                    .padding(.horizontal, ViewSpacing.base)
                    .padding(.vertical, ViewSpacing.small)
                }
            }
            .padding(.leading, -ViewSpacing.base)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AddTagView: View {
    var onCancel: () -> Void
    var onDone: (String) -> Void
    @State private var userInput: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    onCancel()
                    dismiss()
                }) {
                    Text(LocalizedStringKey("cancel"))
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.textSecondary)
                        .frame(height: 28)
                        .frame(minWidth: 72)
                        .background(Color.surfacePrimary)
                }
                
                Spacer()
                
                ButtonView(
                    text: "finished",
                    action: {
                        onDone(userInput.trimmingCharacters(in: .whitespacesAndNewlines))
                        dismiss()
                    },
                    variant: .solid,
                    theme: .action,
                    spacing: .xsmall,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: 72
                )
                .frame(height: 28)
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.top, ViewSpacing.large)
            .padding(.bottom, ViewSpacing.medium)
            
            TextField("", text: $userInput, prompt:Text(LocalizedStringKey("add_tag_placeholder"))
                .font(.typography(.bodyMedium))
                .foregroundColor(.grey200)
            )
            .font(.typography(.bodyMedium))
            .foregroundColor(.textPrimary)
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.top, ViewSpacing.small)
            
            Spacer()
        }
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct MoodDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDiaryView(selectedImage: "calm")
    }
}
