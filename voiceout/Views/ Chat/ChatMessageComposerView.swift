//
//  ChatMessageComposerView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/1/24.
//

import SwiftUI
import StreamChat
import StreamChatUI
import UIKit
import AVFoundation

class CustomMessageContentView: ChatMessageContentView {
    private var avatarImageView: UIImageView?
    private var audioPlayer: AVAudioPlayer?

    override func setUpLayout() {
        super.setUpLayout()

        mainContainer.subviews.forEach { $0.removeFromSuperview() }
        mainContainer.axis = .vertical
        mainContainer.spacing = 4

        backgroundColor = UIColor(Color.surfacePrimaryGrey)

        let outerContainer = UIStackView()
        outerContainer.axis = .horizontal
        outerContainer.spacing = ViewSpacing.small
        outerContainer.alignment = .top
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(outerContainer)
        
        outerContainer.layoutMargins = UIEdgeInsets(top: ViewSpacing.xsmall, left: 0, bottom: ViewSpacing.small, right: 0)
        outerContainer.isLayoutMarginsRelativeArrangement = true

        NSLayoutConstraint.activate([
            outerContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewSpacing.small),
            outerContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewSpacing.small),
            outerContainer.topAnchor.constraint(equalTo: topAnchor),
            outerContainer.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        if !(content?.isSentByCurrentUser ?? true) {
            let avatarView = UIImageView()
            avatarView.contentMode = .scaleAspectFill
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = ViewSpacing.medium
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView = avatarView

            outerContainer.addArrangedSubview(avatarView)

            NSLayoutConstraint.activate([
                avatarView.widthAnchor.constraint(equalToConstant: ViewSpacing.xlarge),
                avatarView.heightAnchor.constraint(equalToConstant: ViewSpacing.xlarge)
            ])
        }

        let innerContainer = UIStackView()
        innerContainer.axis = .vertical
        innerContainer.spacing = ViewSpacing.xsmall
        innerContainer.alignment = content?.isSentByCurrentUser == true ? .trailing : .leading
        outerContainer.addArrangedSubview(innerContainer)

        let bubbleView = UIView()
        bubbleView.layer.cornerRadius = ViewSpacing.medium
        bubbleView.clipsToBounds = true
        bubbleView.backgroundColor = content?.isSentByCurrentUser == true ? UIColor(Color.surfaceBrandPrimary) : UIColor(Color.surfacePrimary)

        if let attachment = content?.imageAttachments.first {
            configureImageMessage(with: attachment, in: bubbleView)
        } else if let audioAttachment = content?.audioAttachments.first {
            configureAudioMessage(with: audioAttachment, in: bubbleView)
        } else if let messageText = content?.text {
            configureTextMessage(messageText, in: bubbleView)
        }

        innerContainer.addArrangedSubview(bubbleView)

        let metadataView = createMetadataView()
        innerContainer.addArrangedSubview(metadataView)
    }

    override func updateContent() {
        super.updateContent()
        
        if let avatarImageView = avatarImageView {
            avatarImageView.image = UIImage(named: "placeholder_avatar")
            
            let defaultAvatarURL = URL(string: "https://s3-alpha-sig.figma.com/img/7644/bf65/bcff340f9b653e44a1598d9c6042065f?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Nt6e9lpCSwfvqxvl71PygUJQCO-jSg20l2aAg0IbBZSkfSP7nQFJduw5P8qJdAAOndVkyB-lMOx4jWpqj-Xb8Yqh5EMEORoceksI5NeQAwQ9f08bssrCCyO7VyrxalqmLhYaZZ~y2qORoy3EJgvl5Q3C1JQSKiAKAnjMfLz8YzbiYuHrKkjUdZjsGZ2-uqRF0AenVc1a-4e1ElPWeM7rZdulrRoKROVnnlN2qQuyWRtm2QOW8QTIdjWbVtE7el4q2yWqLlq2P~MQpOCc12nPydFMEHYapP23iFFqty9p5LHuHUsZ1t5wR6YM4RyGsDafK5Os-gCE16FUGoiit6VMNA__")
            
            let imageURL = content?.author.imageURL ?? defaultAvatarURL
            
            if let imageURL = imageURL {
                URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            avatarImageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }

    private func createMetadataView() -> UIView {
        let timestampLabel = UILabel()
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .lightGray
        if let createdAt = content?.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timestampLabel.text = formatter.string(from: createdAt)
        }

        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = .lightGray
        if content?.isSentByCurrentUser == true {
            switch content?.deliveryStatus {
            case .pending:
                statusLabel.text = "发送中"
            case .sent:
                statusLabel.text = "已发送"
            case .read:
                statusLabel.text = "已读"
            default:
                statusLabel.text = nil
            }
        }

        let metadataStackView = UIStackView(arrangedSubviews: [timestampLabel, statusLabel])
        metadataStackView.axis = .horizontal
        metadataStackView.spacing = ViewSpacing.small
        metadataStackView.alignment = .center
        metadataStackView.distribution = .fillProportionally
        metadataStackView.translatesAutoresizingMaskIntoConstraints = false

        return metadataStackView
    }

    private func configureTextMessage(_ text: String, in bubbleView: UIView) {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.textColor = content?.isSentByCurrentUser == true ? UIColor(Color.textInvert) : UIColor(Color.grey300)
        textLabel.text = text

        bubbleView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: ViewSpacing.small),
            textLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -ViewSpacing.small),
            textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: ViewSpacing.base),
            textLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -ViewSpacing.base)
        ])
    }

    private func configureImageMessage(with attachment: ChatMessageImageAttachment, in bubbleView: UIView) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        bubbleView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)
        ])

        let imageURL = attachment.imageURL
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }

    private func configureAudioMessage(with attachment: ChatMessageAudioAttachment, in bubbleView: UIView) {
        bubbleView.backgroundColor = content?.isSentByCurrentUser == true ? UIColor(Color.surfaceBrandPrimary) : UIColor(Color.surfacePrimary)

        let playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(playButton)

        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            bubbleView.heightAnchor.constraint(equalToConstant: ViewSpacing.xlarge),
            bubbleView.widthAnchor.constraint(equalToConstant: ViewSpacing.xxxxlarge)
        ])

        playButton.accessibilityHint = attachment.audioURL.absoluteString
        playButton.addTarget(self, action: #selector(playAudio(_:)), for: .touchUpInside)
    }

    @objc private func playAudio(_ sender: UIButton) {
        guard let urlString = sender.accessibilityHint, let audioURL = URL(string: urlString) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
}
