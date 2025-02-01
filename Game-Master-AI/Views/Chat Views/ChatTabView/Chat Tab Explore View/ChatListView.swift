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
    @StateObject var vm = ChatTabExploreViewModel()
    @EnvironmentObject var toastProvider: ToastProvider
    @State var searchQuery: String = ""
    @State var isNavigationLinkActivated = false
    @FocusState.Binding var isFocused: Bool
    @State var boardGameSubject = CurrentValueSubject<BoardGameModel?, Never>(nil)

    var body: some View {
        EssentialsLoadingStateView(vm.games) { games in
            VStack(spacing: 8.0) {
                EssentialsSearchBarView(searchText: $searchQuery, isFocused: $isFocused)
                    .onChange(of: searchQuery) { newValue in
                        vm.searchQueryChanged(newValue: newValue)
                    }
                EssentialsListView(games) { boardGame in
                    Text(boardGame.name)
                        .foregroundStyle(Color(.accent))
                } onCellTaped: { boardGame in
                    isFocused = false
                    boardGameSubject.send(boardGame)
                }

                NavigationLink(
                    destination:
                    EssentialsLazyView {
                        ChatView(boardGameModel: boardGameSubject.value!, toastProvider: toastProvider)
                            .onDisappear {
                                boardGameSubject.send(nil)
                            }
                    },
                    isActive: $isNavigationLinkActivated, label: {
                        EmptyView()
                    })
            }
        }
        .task(priority: .userInitiated) { [weak vm] in
            print("appear")
            await vm?.fetchMyCustomGames()
        }
        .onReceive(boardGameSubject) { value in
            if value != nil {
                isFocused = false
                isNavigationLinkActivated = true
            }
        }
        .onAppear {
            print(isNavigationLinkActivated)
        }
        .onTapGesture {
            isFocused = false
        }
        .padding(.bottom, 16.0)
    }
}
