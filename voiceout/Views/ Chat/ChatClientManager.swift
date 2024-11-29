//
//  ChatClientManager.swift
//  voiceout
//
//  Created by Yujia Yang on 11/1/24.
//

import StreamChat
import UIKit

class ChatClientManager {
    static let shared = ChatClientManager()
    let chatClient: ChatClient

    private init() {
        let config = ChatClientConfig(apiKeyString: "m8255hbs4t6f")
        self.chatClient = ChatClient(config: config)
    }

    func connectUser(userId: String, token: Token) {
        chatClient.connectUser(
            userInfo: UserInfo(id: userId),
            token: token
        ) { error in
            if let error = error {
                print("Failed to connect user \(userId): \(error.localizedDescription)")
            } else {
                print("User \(userId) connected successfully")
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectTestUsers()
    }
    
    private func connectTestUsers() {
        let user1Id = "7ee74d29-a1cd-4ab3-8b44-414f1c62bd42"
        let user1Token = Token.development(userId: user1Id)
        ChatClientManager.shared.connectUser(userId: user1Id, token: user1Token)

        let user2Id = "6f3ee4bc-36b4-4f61-b739-2f3799f4082d"
        let user2Token = Token.development(userId: user2Id)
        ChatClientManager.shared.connectUser(userId: user2Id, token: user2Token)
    }
}
