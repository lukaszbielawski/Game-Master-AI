//
//  OnboardingSampleChatViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 14/02/2025.
//

import Foundation

import Combine
import Essentials
import Foundation
import StoreKit

@MainActor
final class OnboardingSampleChatViewModel: ObservableObject {
    private let completionsAPI = EssentialsCompletionsAPIService()
    private let sessionAPI = EssentialsSessionsAPIService()
    private let toastProvider = EssentialsToastProvider.shared

    @Published private(set) var messages: EssentialsLoadingState<[Essentials.EssentialsMessage], EssentialsCompletionsAPIServiceError> = .success([])
    @Published private(set) var streamedMessage: String? = nil

    let boardGameName = "Monopoly"

    lazy var assistantGreetingMessage = EssentialsMessage(role: "assistant", content: """
    Hello! I’m your dedicated \(boardGameName) rules expert. I’m here to help you understand and clarify any questions you have about the rules of \(boardGameName), based solely on its official rulebook. Feel free to ask me anything, such as:

        [Button]How to set up the game[/Button]
        [Button]Rules for winning or ending the game[/Button]

    **You can ask your questions in any language**, and I’ll do my best to assist you!

    If something isn’t specified in the rulebook, I’ll let you know. Let’s dive into \(boardGameName)—what would you like to know?
    """)

    init() {
        messages.appendIfSuccess(assistantGreetingMessage)
    }

    func sendMessage(content: String) async {
        guard !content.isEmpty else { return }
        let newMessage = EssentialsMessage(role: "user", content: content)
        messages.appendIfSuccess(newMessage)
        let request = SampleCompletionsRequest(userQuery: content)

        let result = await completionsAPI.getChatCompletionsStream(
            request: request,
            completionsType: .sample,
            onReceive: { [weak self] chunk, _ in
                if let streamedMessage = self?.streamedMessage {
                    self?.streamedMessage = streamedMessage.appending(chunk)
                } else {
                    self?.streamedMessage = chunk
                }

            })
        switch result {
        case .success(let message):
            messages.appendIfSuccess(message)
            streamedMessage = nil
        case .failure(let error):
            let failureMessage = EssentialsMessage(role: "failure", content: error.message)
            messages.appendIfSuccess(failureMessage)
            print(error)
        }
    }
}
