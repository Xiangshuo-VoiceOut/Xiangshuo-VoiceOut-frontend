//
//  MoodDiaryView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/6/25.
//

import SwiftUI

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
    
    let selectedImage: String
    @EnvironmentObject var router: RouterModel
    
    let locations = [
        "location_home",
        "location_restaurant",
        "location_street",
        "location_office",
        "location_school",
        "location_online",
        "+"
    ]
    let relations = [
        "relation_colleague",
        "relation_family",
        "relation_classmate",
        "relation_stranger",
        "relation_self",
        "relation_friend",
        "+"
    ]
    let reasons = [
        "reason_ignored",
        "reason_stress",
        "reason_misunderstanding",
        "reason_argument",
        "reason_trivial",
        "reason_criticized",
        "+"
    ]
    
    private var diaryHeader: some View {
        StickyHeaderView(
            title: "mood_diary_title",
            leadingComponent: AnyView(
                BackButtonView(action: {
                    if content == .voiceRecorder || content == .selectPicture || content == .customPhotoPicker {
                        content = .diary
                    }
                })
                .foregroundColor(.grey500)
            ),
            trailingComponent: AnyView(
                Group {
                    if !(content == .voiceRecorder || content == .selectPicture || content == .customPhotoPicker) {
                        Button(action: { }) {
                            Image("close").foregroundColor(.grey500)
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
                        onBack: { content = .diary }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    
                case .selectPicture:
                    SelectPictureView(
                        selectedImages: $selectedImages,
                        onBack: { content = .diary },
                        onSend: { images in content = .diary },
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
                TagSelectionView(title: String(localized: "tag_where"), options: locations, selectedTag: $selectedLocation)
                TagSelectionView(title: String(localized: "tag_relation"), options: relations, selectedTag: $selectedRelation)
                TagSelectionView(title: String(localized: "tag_reason"), options: reasons, selectedTag: $selectedReason)
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
                    let newDiary = DiaryEntry(
                        id: nil,
                        userId: "user00123",
                        timestamp: Date(),
                        moodType: selectedImage.lowercased(),
                        keyword: [],
                        intensity: emotionIntensity,
                        location: selectedLocation.isEmpty ? "" : selectedLocation,
                        persons: selectedRelation.isEmpty ? [] : [selectedRelation],
                        reasons: selectedReason.isEmpty ? [] : [selectedReason],
                        diaryText: storyText.isEmpty ? "" : storyText,
                        selectedImage: selectedImage,
                        attachments: Attachments(voiceUrl: "", imageUrls: [])
                    )
                    
                    MoodManagerService.shared.createDiaryEntry(entry: newDiary) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let response):
                                router.navigateTo(.moodManagerLoading)
                            case .failure(let error):
                                print("Diary failure:", error.localizedDescription)
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
                    .overlay(Circle().stroke(Color.grey50, lineWidth: 2))
                }
                
            }
            .padding(.top, ViewSpacing.small)
            .padding(.bottom, ViewSpacing.medium)
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
}

struct TagSelectionView: View {
    let title: String
    let options: [String]
    @Binding var selectedTag: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            Text(title)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            
            FlowLayout {
                ForEach(options, id: \.self) { item in
                    ButtonView(
                        text: item,
                        action: { selectedTag = item },
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

struct MoodDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDiaryView(selectedImage: "calm")
    }
}
