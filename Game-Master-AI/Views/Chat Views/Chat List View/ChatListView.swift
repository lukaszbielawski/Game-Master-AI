//
//  ChatListView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Combine
import Essentials
import SwiftUI

struct ChatListView: View {
    @StateObject var vm: ChatListViewModel = .init()
    @ObservedObject var router = RouterState.shared
    @ObservedObject var tabRouter = TabRouterState.shared
    @FocusState.Binding var isFocused: Bool
    @ObservedObject private var subscriptionState = EssentialsSubscriptionState.shared

    private let toastProvider = EssentialsToastProvider.shared

    @State var searchQuery: String = ""
    @State var isInEditMode: Bool = false
    @State private var boardGameToDelete: BoardGameModel? = nil

    init(isFocused: FocusState<Bool>.Binding) {
        self._isFocused = isFocused
    }

    var isAlertPresented: Binding<Bool> {
        return Binding<Bool> {
            boardGameToDelete != nil
        } set: { value, _ in
            if value == false {
                boardGameToDelete = nil
            }
        }
    }

    var body: some View {
        EssentialsLoadingStateView(vm.games) { games in
            VStack(spacing: 8.0) {
                EssentialsSearchBarView(searchText: $searchQuery, isFocused: $isFocused)
                    .onChange(of: searchQuery) { newValue in
                        vm.searchQueryChanged(newValue: newValue)
                    }
                Label("Add new game", systemImage: "plus")
                    .foregroundStyle(Color(.accent))
                    .padding(.vertical, 9.0)
                    .modifier(EssentialsListCellModifier())
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.listElementBackgroundColor)
                    }

                    .padding(.horizontal, 24.0)
                    .padding(.bottom, 4.0)
                    .padding(.top, 24.0)
                    .onTapGesture {
                        if vm.canAddGame {
                            EssentialsHapticService.shared.play(.light)
                            router.currentSheetRoute = .addBoardGameView
                        } else {
                            EssentialsHapticService.shared.notify(.warning)
                            let toast: EssentialsToast
                            if subscriptionState.isActive {
                                toast = .failure("You have reached monthly limit for new games. Please wait until the next cycle.")
                            } else {
                                toast = .failure("You cannot add any more games. Please purchase premium to continue.")
                                router.push(.paywallView(hasTrial: false))
                            }
                            toastProvider.enqueueToast(toast)
                        }
                    }

                let filteredGames = games.filter { game in
                    guard let filterPredicate = vm.filterPredicate else { return true }
                    guard let predicateResult = try? filterPredicate(game), predicateResult else { return false }
                    return true
                }

                EssentialsListView(filteredGames) { _, boardGame in
                    Text(boardGame.name)
                        .swipeActionDelete(model: boardGame) { boardGameToDelete in
                            EssentialsHapticService.shared.notify(.warning)
                            self.boardGameToDelete = boardGameToDelete
                        }
                } onCellTapped: { boardGame in
                    isFocused = false
                    EssentialsHapticService.shared.play(.soft)
                    router.push(.chatView(boardGame))
                }
                .alert(
                    "Delete \(boardGameToDelete?.name ?? "the game")?",
                    isPresented: isAlertPresented,
                    actions: {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) { [weak vm] in
                            guard let boardGameToDelete else { return }
                            Task { @MainActor in
                                await vm?.deleteBoardGame(boardGameToDelete)
                            }
                        }
                    },
                    message: {
                        Text("You can add \(vm.remainingGameCreations) more games this month.")
                    }
                )
            }

        } failureView: { error in
            EssentialsContentUnavailableView(
                icon: Image(systemName: "wifi.slash"),
                title: "No Connection",
                description: "There was a problem connecting to the internet. Please check your connection and try again."
            ) {
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.fetchMyCustomGames()
                }
            }
            .onAppear {
                if let error = error as? EssentialsToastProvidableError {
                    toastProvider.enqueueToast(EssentialsToast(fromError: error))
                }
            }
        }
        .onAppear {
            tabRouter.currentToolbarRoute = .chatListView
        }
        .onTapGesture {
            isFocused = false
        }
        .padding(.bottom, 16.0)
    }
}
