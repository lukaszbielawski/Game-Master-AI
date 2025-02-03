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
    let boardGameModel: BoardGameModel

    public init(boardGameModel: BoardGameModel, toastProvider: EssentialsToastProvider) {
        self.boardGameModel = boardGameModel
        self._vm = StateObject(wrappedValue: ChatViewModel(boardGameModel: boardGameModel, toastProvider: toastProvider))
    }

    var body: some View {
        EssentialsLoadingStateView(vm.messages) { messages in
            EssentialsChatView(messages: messages,
                               streamedMessageContent: vm.streamedMessageContent,
                               navigationTitle: boardGameModel.name)
            { messageContent in
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.sendMessage(content: messageContent)
                }
            } onNewConversationButtonTapped: { [weak vm] in
                Task(priority: .userInitiated) {
                    await vm?.resetConversation()
                }
            }
        }
        .task { [weak vm] in
            await vm?.fetchAllMessages()
        }
    }
}
