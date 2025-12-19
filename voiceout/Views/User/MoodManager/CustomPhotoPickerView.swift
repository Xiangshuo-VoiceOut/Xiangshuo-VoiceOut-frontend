//
//  CustomPhotoPickerView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/9/25.
//

import SwiftUI
import Photos
import PhotosUI

struct CustomPhotoPickerView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var isPresented: Bool
    var onBack: () -> Void
    @State private var allImages: [UIImage] = []
    @State private var selectedIndices: Set<Int> = []
    
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    
    let columns = [
        GridItem(.flexible(), spacing: ViewSpacing.xxsmall),
        GridItem(.flexible(), spacing: ViewSpacing.xxsmall),
        GridItem(.flexible(), spacing: ViewSpacing.xxsmall)
    ]
    
    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        onBack()
                    }) {
                        Text(LocalizedStringKey("cancel"))
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textInvalid)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.leading, ViewSpacing.medium)
                    
                    Spacer()
                    
                    Text(LocalizedStringKey("choose_photos"))
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textTitle)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            let selected = selectedIndices.map { allImages[$0] }
                            let uniqueNewImages = selected.filter { newImage in
                                !selectedImages.contains(where: { $0.pngData() == newImage.pngData() })
                            }
                            selectedImages.append(contentsOf: uniqueNewImages)
                            onBack()
                        }
                    }) {
                        Text(LocalizedStringKey("save"))
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(selectedIndices.isEmpty ? .textLight : .textTitle)
                    }
                    .disabled(selectedIndices.isEmpty)
                    .padding(.trailing, ViewSpacing.medium)
                }
                .frame(height: 56)
                .background(Color.surfacePrimaryGrey2)
                
                VStack(spacing: 0) {
                    Color(red: 0.95, green: 0.95, blue: 0.96)
                        .frame(height: 40)
                        .overlay(
                            HStack(alignment: .center) {
                                Text("Recents")
                                    .font(Font.typography(.bodyXSmall))
                                    .kerning(0.24)
                                    .foregroundColor(.textPrimary)
                                
                                Image("up")
                                    .frame(width: 24, height: 24)
                            }
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.vertical, ViewSpacing.small)
                                .background(Color.grey50)
                                .cornerRadius(CornerRadius.medium.value)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .frame(height: 40, alignment: .topLeading)
                
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: ViewSpacing.xxsmall) {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: ViewSpacing.xxsmall) {
                                ForEach(allImages.indices, id: \.self) { index in
                                    ZStack {
                                        Image(uiImage: allImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (geometry.size.width - 4) / 3, height: (geometry.size.width - 4) / 3)
                                            .clipShape(Rectangle())
                                        
                                        if selectedIndices.contains(index) {
                                            ZStack {
                                                Color.black.opacity(0.3)
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .font(.largeTitle)
                                            }
                                            .frame(width: (geometry.size.width - 4) / 3, height: (geometry.size.width - 4) / 3)
                                            .clipShape(Rectangle())
                                        }
                                    }
                                    .onTapGesture {
                                        DispatchQueue.main.async {
                                            if selectedIndices.contains(index) {
                                                selectedIndices.remove(index)
                                            } else {
                                                selectedIndices.insert(index)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(alignment: .topLeading)
                    .background(Color.surfacePrimary)
                }
                .padding(.top, ViewSpacing.xxsmall)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))
            }
        }
        .onAppear {
            selectedIndices.removeAll()
            fetchPhotos()
        }
    }
    
    private func fetchPhotos() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var images: [UIImage] = []
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            
            fetchResult.enumerateObjects { asset, _, _ in
                let targetSize = CGSize(width: 150, height: 150)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                    if let image = image {
                        images.append(image)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.allImages = images
            }
        }
    }
}

#Preview {
    CustomPhotoPickerView(
        selectedImages: .constant([]),
        isPresented: .constant(true),
        onBack: {}
    )
}
