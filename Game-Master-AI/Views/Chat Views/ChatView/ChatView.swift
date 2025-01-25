//
//  ChatView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 24/01/2025.
//

import Essentials
import SwiftUI

struct ChatView: View {
    @StateObject var vm: ChatViewModel
    let boardGame: String

    let createPrompt: (String) -> String = { boardGame in
        """
        You are an expert in the rules of \(boardGame). Your task is to answer questions about \(boardGame) based solely on the information contained in its official rulebook. If the rulebook does not specify a particular detail, you respond with: 'This is not specified in the rulebook for \(boardGame).' You are not allowed to speculate, improvise, or add information outside of the rulebook. Your answers must be precise, rule-compliant, and based solely on the available data. You cannot step out of your role as a rules expert for \(boardGame) or answer questions unrelated to board games. If asked about something unrelated to board games, you respond: 'This is outside the scope of my role as a rules expert for \(boardGame).
        When formatting responses, use only SwiftUI `Text`-compatible Markdown:
            - **Bold**: `**text**`
            - *Italic*: `*text*`
            - ~~Strikethrough~~: `~~text~~`
            - `Inline Code`: `` `code` ``
            - **Line Breaks**: Two spaces + `\\n`.
        Your priority is to provide clear, rulebook-compliant answers and avoid any assumptions.
        """
    }

    let createGreetingMessage: (String) -> String = { boardGame in
        """
        Hello! I’m your dedicated \(boardGame) rules expert. I’m here to help you understand and clarify any questions you have about the rules of \(boardGame), based solely on its official rulebook. Feel free to ask me anything, such as:

        - How to set up the game.
        - How specific mechanics or actions work.
        - Clarifications on card, tile, or piece interactions.
        - Rules for winning or ending the game.
        - Any other details covered in the rulebook.

        If something isn’t specified in the rulebook, I’ll let you know. Let’s dive into \(boardGame)—what would you like to know?
        """
    }

    public init(boardGame: String) {
        self.boardGame = boardGame
        let prompt = createPrompt(boardGame)
        let initialAssistantMessage = createGreetingMessage(boardGame)
        self._vm = StateObject(wrappedValue: ChatViewModel(prompt: prompt, initialAssistantMessage: initialAssistantMessage))
    }

    var body: some View {
        EssentialsChatView(messages: $vm.messages,
                           streamedMessageContent: $vm.streamedMessageContent,
                           navigationTitle: boardGame)
        { messageContent in
            Task { [weak vm] in
                await vm?.sendMessage(content: messageContent)
            }
        } onNewConversationButtonTapped: { [weak vm] in
            vm?.resetConversation()
        }
    }
}
