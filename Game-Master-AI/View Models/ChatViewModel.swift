//
//  ChatViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 11/01/2025.
//

import Essentials
import Foundation
import StoreKit

final class ChatViewModel: ObservableObject {
    private let prompt: String
    private let chatAPI: ChatAPI

    @Published var messages: [Essentials.Message] = []
    @Published var streamedMessage: String = ""

    init(chatAPI: ChatAPI, prompt: String) {
        self.chatAPI = chatAPI
        self.prompt = prompt
    }

    func sendMessage(content: String) async {
        let newMessage = Message(role: "user", content: content)
        messages.append(newMessage)

        let result = await chatAPI.getChatCompletionStream(
            prompt: prompt,
            messages: messages,
            deployEnvironment: .simulator,
            onReceive: { [weak self] chunk in
                self?.streamedMessage.append(chunk)
            })
        switch result {
        case .success(let message):
            messages.append(message)
        case .failure(let error):
            print("Error:", error)
        }
    }
}
