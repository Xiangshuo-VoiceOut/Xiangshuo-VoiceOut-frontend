//
//  ChatFrameView.swift
//  voiceout
//
//  Created by Yujia Yang on 31/10/24.
//

import SwiftUI
import StreamChat
import StreamChatUI

struct ChatFrameView: View {
    var userId: String
    var userName: String

    init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName

        if Components.default.messageContentView != CustomMessageContentView.self {
            var components = Components.default
            components.messageContentView = CustomMessageContentView.self
            components.messageLayoutOptionsResolver = CustomLayoutOptionsResolver()
            Components.default = components
        }

        let token = Token.development(userId: userId)
        ChatClientManager.shared.connectUser(userId: userId, token: token)
    }

    var body: some View {
        ChatChannelViewControllerRepresentable(userId: userId, userName: userName)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ChatChannelViewControllerRepresentable: UIViewControllerRepresentable {
    var userId: String
    var userName: String

    func makeUIViewController(context: Context) -> CustomChatChannelVC {
        let chatChannelVC = CustomChatChannelVC(userName: userName)
        let client = ChatClientManager.shared.chatClient
        let channelController = client.channelController(for: ChannelId(type: .messaging, id: "5pysajjw9ug7"))
        chatChannelVC.channelController = channelController

        channelController.addMembers(userIds: ["7ee74d29-a1cd-4ab3-8b44-414f1c62bd42", "6f3ee4bc-36b4-4f61-b739-2f3799f4082d"]) { error in
            if let error = error {
                print("Failed to add members to the channel: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    channelController.synchronize { syncError in
                        if let syncError = syncError {
                            print("Synchronization error: \(syncError.localizedDescription)")
                        } else {
                            print("Channel synchronized successfully for user \(userId)")
                        }
                    }
                }
            }
        }

        return chatChannelVC
    }

    func updateUIViewController(_ uiViewController: CustomChatChannelVC, context: Context) {}
}

class CustomLayoutOptionsResolver: ChatMessageLayoutOptionsResolver {
    override func optionsForMessage(
        at indexPath: IndexPath,
        in channel: ChatChannel,
        with messages: AnyRandomAccessCollection<ChatMessage>,
        appearance: Appearance
    ) -> ChatMessageLayoutOptions {
        var options: ChatMessageLayoutOptions = [.bubble]
        let messageArray = Array(messages)
        let message = messageArray[indexPath.item]
        
        if !message.isSentByCurrentUser {
            options.insert(.avatar)
        }
        if message.isSentByCurrentUser {
            options.insert(.flipped)
        }
        return options
    }
}

#Preview {
    ChatFrameView(userId: "7ee74d29-a1cd-4ab3-8b44-414f1c62bd42", userName: "咨询师刘雨")
    //ChatFrameView(userId: "6f3ee4bc-36b4-4f61-b739-2f3799f4082d", userName: "小云朵")
}
