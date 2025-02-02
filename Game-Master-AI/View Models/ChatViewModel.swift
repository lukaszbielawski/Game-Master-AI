//
//  ChatViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 11/01/2025.
//

import Combine
import Essentials
import Foundation
import StoreKit

@MainActor
final class ChatViewModel: ObservableObject {
    private let completionsAPI = EssentialsCompletionsAPIService<BoardGameCompletionsRequest>()
    private let sessionAPI = EssentialsSessionsAPIService()
    private let boardGameModel: BoardGameModel
    private let toastProvider: ToastProvider

    @Published private(set) var messages: EssentialsLoadingState<[Essentials.Message]> = .initial
    @Published private(set) var streamedMessageContent: String? = nil

    lazy var assistantGreetingMessage = Message(role: "assistant", content: """
    Hello! I’m your dedicated \(boardGameModel.name) rules expert. I’m here to help you understand and clarify any questions you have about the rules of \(boardGameModel.name), based solely on its official rulebook. Feel free to ask me anything, such as:

    - How to set up the game.
    - How specific mechanics or actions work.
    - Clarifications on card, tile, or piece interactions.
    - Rules for winning or ending the game.
    - Any other details covered in the rulebook.

    If something isn’t specified in the rulebook, I’ll let you know. Let’s dive into \(boardGameModel.name)—what would you like to know?
    """)

    init(boardGameModel: BoardGameModel, toastProvider: ToastProvider) {
        self.boardGameModel = boardGameModel
        self.toastProvider = toastProvider
    }

    func fetchAllMessages() async {
        messages = .initial
        switch await sessionAPI.getSessionMessages(sessionId: boardGameModel.sessionId) {
        case .success(let response):
            var fetchedMessages = response.messages
            fetchedMessages.insert(assistantGreetingMessage, at: 0)
            messages = .success(fetchedMessages)
        case .failure(let error):
            messages = .failure(error: error)
        }
    }

    func resetConversation() async {
        messages = .success([assistantGreetingMessage])
        switch await sessionAPI.resetSession(sessionId: boardGameModel.sessionId) {
        case .success:
            toastProvider.enqueueToast(.success("New session started!"))
        case .failure:
            toastProvider.enqueueToast(.failure("Could not reset a session. Please try again"))
        }
    }

    func sendMessage(content: String) async {
        guard !content.isEmpty else { return }

        let newMessage = Message(role: "user", content: content)
        messages.appendIfSuccess(newMessage)
        let request = BoardGameCompletionsRequest(boardGameId: boardGameModel.id, userQuery: content)

        let result = await completionsAPI.getChatCompletionsStream(
            request: request,
            onReceive: { [weak self] chunk in
                if self?.streamedMessageContent == nil {
                    self?.streamedMessageContent = ""
                }
                self?.streamedMessageContent?.append(chunk)
            })
        switch result {
        case .success(let message):
            messages.appendIfSuccess(message)
            streamedMessageContent = nil
        case .failure(let error):
            print("Error:", error)
        }
    }
}
