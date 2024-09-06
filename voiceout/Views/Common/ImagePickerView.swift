//
//  ImagePickerView.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            Button(action: {
                showImagePicker = true
            }) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 100)
                        .clipShape(Rectangle())
                } else {
                    Rectangle()
                        .fill(Color.surfacePrimary)
                        .frame(width: 120, height: 100)
                        .overlay(
                            Image("drive-folder-upload")
                        )
                        .overlay(
                            Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: StrokeWidth.width100.value, dash: [4, 4]))
                                .foregroundColor(Color.borderBrandPrimary)
                        )

                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.selectedImage = image

                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var completionHandler: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker

            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.completionHandler(image)
                }
                picker.dismiss(animated: true)
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
}

#Preview {
    ImagePickerView()
}
