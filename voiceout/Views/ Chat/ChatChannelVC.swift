//
//  ChatChannelVC.swift
//  voiceout
//
//  Created by Yujia Yang on 11/1/24.
//

import SwiftUI
import StreamChat
import StreamChatUI
import UIKit
import AVFoundation

class CustomChatChannelVC: ChatChannelVC {
    private var isSynchronized = false
    private let userName: String

    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
        
        Components.default.messageComposerVC = CustomComposerVC.self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUp() {
        super.setUp()
        
        let headerView = StickyHeaderView(
            title: userName,
            leadingComponent: AnyView(BackButtonView(navigateBackTo: .therapistLogin)),
            trailingComponent: AnyView(
                Button(action: {
                    print("Settings button tapped")
                }) {
                    Image("Setting-two")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
            )
        )
        let hostingController = UIHostingController(rootView: headerView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
        hostingController.didMove(toParent: self)
        
        let messageListView = messageListVC.view!
        view.addSubview(messageListView)
        messageListView.translatesAutoresizingMaskIntoConstraints = false
        
        let customComposerVC = CustomComposerVC()
        addChild(customComposerVC)
        customComposerVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customComposerVC.view)
        
        NSLayoutConstraint.activate([
            messageListView.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            messageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageListView.bottomAnchor.constraint(equalTo: customComposerVC.view.topAnchor),
            
            customComposerVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customComposerVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customComposerVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customComposerVC.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        customComposerVC.didMove(toParent: self)
        
        if !isSynchronized {
            channelController.synchronize { error in
                if let error = error {
                    print("Synchronization error: \(error.localizedDescription)")
                } else {
                    print("Synchronization successful")
                }
            }
            isSynchronized = true
        }
        
        channelController.delegate = self
    }

    class CustomComposerVC: ComposerVC, AVAudioRecorderDelegate {
        private let inputContainerView = UIView()
        private let inputTextView = UITextView()
        private var audioRecorder: AVAudioRecorder?
        private var audioFileURL: URL?
        private var isRecording = false
        private var selectedImageURL: URL?

        override func setUpLayout() {
            super.setUpLayout()
            
            composerView.subviews.forEach { $0.removeFromSuperview() }
            
            let plusButton = UIButton(type: .system)
            plusButton.setImage(UIImage(named: "add-round")?.withRenderingMode(.alwaysOriginal), for: .normal)
            plusButton.addTarget(self, action: #selector(showOptionsMenu), for: .touchUpInside)
            plusButton.translatesAutoresizingMaskIntoConstraints = false
            composerView.addSubview(plusButton)
            
            inputContainerView.layer.cornerRadius = CornerRadius.medium.value
            inputContainerView.layer.borderWidth = 1
            inputContainerView.layer.borderColor = UIColor.lightGray.cgColor
            inputContainerView.translatesAutoresizingMaskIntoConstraints = false
            composerView.addSubview(inputContainerView)
            
            inputTextView.font = UIFont.systemFont(ofSize: 16)
            inputTextView.backgroundColor = .clear
            inputTextView.isEditable = true
            inputTextView.isUserInteractionEnabled = true
            inputTextView.delegate = self
            inputTextView.translatesAutoresizingMaskIntoConstraints = false
            inputContainerView.addSubview(inputTextView)
            
            let microphoneButton = UIButton(type: .system)
            microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            microphoneButton.tintColor = .gray
            microphoneButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
            microphoneButton.translatesAutoresizingMaskIntoConstraints = false
            inputContainerView.addSubview(microphoneButton)
            
            NSLayoutConstraint.activate([
                plusButton.leadingAnchor.constraint(equalTo: composerView.leadingAnchor, constant: ViewSpacing.base),
                plusButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
                
                inputContainerView.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: ViewSpacing.small),
                inputContainerView.trailingAnchor.constraint(equalTo: composerView.trailingAnchor, constant: -ViewSpacing.base),
                inputContainerView.topAnchor.constraint(equalTo: composerView.topAnchor, constant: ViewSpacing.small),
                inputContainerView.heightAnchor.constraint(equalToConstant: ViewSpacing.xlarge),
                
                inputTextView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: ViewSpacing.base),
                inputTextView.trailingAnchor.constraint(equalTo: microphoneButton.leadingAnchor, constant: -ViewSpacing.base),
                inputTextView.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
                inputTextView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor),

                microphoneButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -ViewSpacing.base),
                microphoneButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor)
            ])
        }

        @objc private func toggleRecording() {
            if isRecording {
                stopRecording()
            } else {
                startRecording()
            }
            isRecording.toggle()
        }

        private func startRecording() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)

                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]

                audioFileURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("m4a")
                audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
                audioRecorder?.record()

                print("Recording started")
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
            }
        }

        private func stopRecording() {
            audioRecorder?.stop()
            audioRecorder = nil
            print("Recording stopped")
            
            if let audioURL = audioFileURL,
               let channelController = (self.parent as? CustomChatChannelVC)?.channelController {
                do {
                    try channelController.createNewMessage(text: "", attachments: [.init(localFileURL: audioURL, attachmentType: .audio)]) { result in
                        switch result {
                        case .success:
                            print("Audio sent successfully")
                        case .failure(let error):
                            print("Failed to send audio: \(error)")
                        }
                    }
                } catch {
                    print("Failed to create message with audio: \(error.localizedDescription)")
                }
            }
        }

        @objc private func showOptionsMenu() {
            let actionSheet = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "拍摄", style: .default) { _ in
                self.openCamera()
            })
            
            actionSheet.addAction(UIAlertAction(title: "图片", style: .default) { _ in
                self.openPhotoLibrary()
            })

            actionSheet.addAction(UIAlertAction(title: "文件", style: .default) { _ in
                self.selectFile()
            })
            
            actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
            if let parentVC = parent {
                parentVC.present(actionSheet, animated: true, completion: nil)
            }
        }

        @objc private func openCamera() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("Camera not available")
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            parent?.present(picker, animated: true, completion: nil)
        }
        
        @objc private func openPhotoLibrary() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Photo library not available")
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            parent?.present(picker, animated: true, completion: nil)
        }

        @objc private func selectFile() {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
            documentPicker.delegate = self
            parent?.present(documentPicker, animated: true, completion: nil)
        }
        
        override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            if let image = info[.originalImage] as? UIImage {
                let tempURL = saveImageToTemp(image: image)
                selectedImageURL = tempURL
                
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = resizeImage(image: image, to: CGSize(width: 50, height: 50))
                inputTextView.textStorage.insert(NSAttributedString(attachment: imageAttachment), at: 0)
            }
        }
        
        private func saveImageToTemp(image: UIImage) -> URL {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                try? imageData.write(to: tempURL)
            }
            return tempURL
        }

        private func resizeImage(image: UIImage, to size: CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage ?? image
        }

        override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                sendMessage()
                return false
            }
            return true
        }

        private func sendMessage() {
            guard let channelController = (self.parent as? CustomChatChannelVC)?.channelController,
                  let text = inputTextView.text, !text.isEmpty else { return }
            channelController.createNewMessage(text: text) { result in
                switch result {
                case .success:
                    print("Message sent successfully")
                case .failure(let error):
                    print("Failed to send message: \(error)")
                }
            }
            inputTextView.text = ""
        }
    }
}
