//
//  ChatManager.swift
//  voiceout
//
//  Created by Yujia Yang on 11/2/24.
//

import StreamChat
import StreamChatUI
import UIKit

final class ChatManager {
    static let shared = ChatManager()
    
    var client: ChatClient!
    
    func setUp() {
        let client = ChatClient(config: .init(apiKey: .init("m8255hbs4t6f")))
        self.client = client
    }

    private let tokens: [String: String] = [
        "咨询师刘雨": "7ee74d29-a1cd-4ab3-8b44-414f1c62bd42"
    ]

    func connectUser(with username: String, completion: @escaping (Bool) -> Void) {
        guard let token = tokens[username.lowercased()] else {
            completion(false)
            return
        }

        client.connectUser(
            userInfo: UserInfo(id: username, name: username),
            token: Token(stringLiteral: token)
        ) { error in
            if let error = error {
                print("Failed to connect user: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User connected successfully: \(username)")
                completion(true)
            }
        }
    }

    func fetchChannels(for username: String, completion: @escaping ([ChatChannel]) -> Void) {
        let query = ChannelListQuery(filter: .containMembers(userIds: [username]))
        let controller = client.channelListController(query: query)
        controller.synchronize { error in
            if let error = error {
                print("Failed to fetch channels: \(error.localizedDescription)")
                completion([])
            } else {
                completion(Array(controller.channels))
            }
        }
    }

    var currentUser: String? {
        return client.currentUserId
    }
    
    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else { return nil }

        let list = client.channelListController(query: .init(filter: .containMembers(userIds: [id])))
        let vc = ChatChannelListVC()
        vc.content = list
        list.synchronize()
        return vc
    }
}
