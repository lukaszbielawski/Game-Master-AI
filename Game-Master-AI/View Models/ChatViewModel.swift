//
//  ChatViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 11/01/2025.
//

import Essentials
import Foundation
import StoreKit

@MainActor
final class ChatViewModel: ObservableObject {
    private let prompt: String
    private let chatAPI = ChatAPI()
    private let initialAssistantMessage: String

    @Published var messages: [Essentials.Message] = []
    @Published var streamedMessageContent: String? = nil

    init(chatAPI: ChatAPI = ChatAPI(), prompt: String, initialAssistantMessage: String) {
        self.prompt = prompt
        self.initialAssistantMessage = initialAssistantMessage
        resetConversation()
    }

    func resetConversation() {
        messages.removeAll()
        let greetingsMessage = Message(role: "assistant", content: initialAssistantMessage)
        messages.append(greetingsMessage)
    }

    func sendMessage(content: String) async {
        let newMessage = Message(role: "user", content: content)
        messages.append(newMessage)

        let result = await chatAPI.getChatCompletionStream(
            prompt: prompt,
            messages: messages,
            onReceive: { [weak self] chunk in
                if self?.streamedMessageContent == nil {
                    self?.streamedMessageContent = ""
                }
                self?.streamedMessageContent?.append(chunk)
            })
        switch result {
        case .success(let message):
            messages.append(message)
            streamedMessageContent = nil
        case .failure(let error):
            print("Error:", error)
        }
    }
}
