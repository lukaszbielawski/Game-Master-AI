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
    @Environment(\.dismiss) var dismiss
    @ObservedObject var router = RouterState.shared

    public init(boardGameModel: BoardGameModel) {
        self.boardGameModel = boardGameModel
        self._vm = StateObject(wrappedValue: ChatViewModel(boardGameModel: boardGameModel))
    }

    var body: some View {
        EssentialsLoadingStateView(vm.messages) { messages in
            EssentialsChatView(
                navigationRouteType: NavigationRoute.self,
                sheetRouteType: SheetRoute.self,
                toolbarRouteType: TabToolbarRoute.self,
                messages: messages,
                streamedMessage: vm.streamedMessage,
                maxCharactersInTextField: 2000,
                navigationTitle: boardGameModel.name,
                volumeFractions: vm.volumeFractions,
                recordingDurationSeconds: vm.recordingDurationSeconds,
                recordingState: vm.recordingState
            ) { messageContent in
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.sendMessage(content: messageContent)
                }
            } onNewConversationButtonTapped: { [weak vm] in
                Task(priority: .userInitiated) {
                    await vm?.resetConversation()
                }
            } onRecordButtonTapped: { [weak vm] in
                guard let vm else { return }
                if vm.recordingState == .recording {
                    EssentialsHapticService.shared.play(.soft)
                    Task(priority: .userInitiated) {
                        await vm.stopRecording()
                    }
                } else if vm.recordingState == .stopped {
                    EssentialsHapticService.shared.play(.soft)
                    Task(priority: .userInitiated) {
                        await vm.startRecording()
                    }
                }
            } onCancelRecordButtonTapped: {
                Task(priority: .userInitiated) { [weak vm] in
                    guard let vm else { return }
                    await vm.cancelRecording()
                }
            }
        } failureView: { _ in
            EssentialsContentUnavailableView(
                icon: Image(systemName: "wifi.slash"),
                title: "No Connection",
                description: "There was a problem connecting to the internet. Please check your connection and try again."
            ) {
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.fetchAllMessages()
                }
            }
            .toolbar {
                ChatViewFailureToolbar {
                    EssentialsHapticService.shared.play(.medium)
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .task(priority: .userInitiated) { [weak vm] in
            await vm?.fetchAllMessages()
        }
    }
}
