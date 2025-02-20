//
//  OnboardingSampleChatView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 14/02/2025.
//

import Essentials
import SwiftUI

struct OnboardingSampleChatView: View {
    @StateObject var vm: OnboardingSampleChatViewModel = .init()
    @Environment(\.dismiss) var dismiss
    @ObservedObject var router = RouterState.shared
    let onSend: () -> Void

    var body: some View {
        EssentialsLoadingStateView(vm.messages) { messages in
            EssentialsChatView(
                navigationRouteType: NavigationRoute.self,
                sheetRouteType: SheetRoute.self,
                toolbarRouteType: TabToolbarRoute.self,
                messages: messages,
                streamedMessage: vm.streamedMessage,
                maxCharactersInTextField: 2000,
                navigationTitle: vm.boardGameName,
                isSampleChatView: true
            ) { messageContent in
                onSend()
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.sendMessage(content: messageContent)
                }
            } onNewConversationButtonTapped: {}
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}
