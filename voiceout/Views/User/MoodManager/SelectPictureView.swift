//
//  SelectPictureView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/9/25.
//

import SwiftUI
import PhotosUI

struct SelectPictureView: View {
    @Binding var selectedImages: [UIImage]
    var onBack: () -> Void
    var onSend: ([UIImage]) -> Void
    var onPhotoPicker: () -> Void

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
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: ViewSpacing.xxsmall) {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: ViewSpacing.xxsmall) {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (geometry.size.width - 4) / 3, height: (geometry.size.width - 4) / 3)
                                        .clipShape(Rectangle())
                                }
                            }
                            .padding(.horizontal, ViewSpacing.xxxsmall)
                        }
                    }
                    .frame(alignment: .topLeading)
                    .background(Color.surfacePrimaryGrey2)
                }
                .padding(.top, 2 * ViewSpacing.betweenSmallAndBase)

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: ViewSpacing.medium)
                        .fill(Color.grey50)
                        .frame(height: 88)
                        .padding(.horizontal, ViewSpacing.xlarge)

                    HStack(alignment: .top, spacing: ViewSpacing.large) {
                        Button(action: {
                            onPhotoPicker()
                        }) {
                            VStack(spacing: ViewSpacing.xsmall) {
                                Circle()
                                    .fill(Color.surfaceBrandPrimary)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image("photo")
                                            .frame(width: 17, height: 17)
                                    )
                                Text(LocalizedStringKey("photos"))
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textSecondary)
                            }
                        }

                        Button(action: { showCameraPicker = true }) {
                            VStack(spacing: ViewSpacing.xsmall) {
                                Circle()
                                    .fill(Color.surfaceBrandPrimary)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image("camera-outline")
                                            .frame(width: 24, height: 24)
                                    )
                                Text(LocalizedStringKey("camera"))
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textSecondary)
                            }
                        }

                        Spacer()
                    }
                    .frame(height: 64)
                    .padding(.horizontal, 2 * ViewSpacing.xlarge)
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, ViewSpacing.xlarge)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            CustomPhotoPickerView(
                selectedImages: $selectedImages,
                isPresented: $showImagePicker,
                onBack: { showImagePicker = false } 
            )
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPicker(selectedImage: $selectedImages)
                .ignoresSafeArea()
        }
    }
}



struct CustomPhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let picker = PHPickerViewController(configuration: makePickerConfig())
        picker.delegate = context.coordinator
        picker.view.backgroundColor = .black

        viewController.view.addSubview(picker.view)
        viewController.addChild(picker)
        picker.didMove(toParent: viewController)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makePickerConfig() -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.selectionLimit = 9
        config.filter = .images
        return config
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: CustomPhotoPicker

        init(_ parent: CustomPhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let dispatchGroup = DispatchGroup()
            var images: [UIImage] = []

            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.parent.selectedImages = images
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage.append(image)
            }
            picker.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SelectPictureView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPictureView(
            selectedImages: .constant([]),
            onBack: {},
            onSend: { _ in },
            onPhotoPicker: {}
        )
    }
}
