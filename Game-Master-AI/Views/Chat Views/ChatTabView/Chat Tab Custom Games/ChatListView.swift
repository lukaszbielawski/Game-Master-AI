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
    @StateObject var vm = ChatTabCustomGamesViewModel()
    @EnvironmentObject var toastProvider: ToastProvider
    @State var searchQuery: String = ""
    @State var isNavigationLinkActivated = false
    @FocusState.Binding var isFocused: Bool
    @State var boardGameSubject = CurrentValueSubject<BoardGameModel?, Never>(nil)
    @State private var isAddNewGameSheetPresented = false

    var body: some View {
        EssentialsLoadingStateView(vm.games) { games in
            VStack(spacing: 8.0) {
                EssentialsSearchBarView(searchText: $searchQuery, isFocused: $isFocused)
                    .onChange(of: searchQuery) { newValue in
                        vm.searchQueryChanged(newValue: newValue)
                    }
                Label("Add new game", systemImage: "plus")
                    .modifier(EssentialsListCellModifier())
                    .foregroundStyle(Color(.accent))
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.listElementBackgroundColor)
                    }
                    .padding(.horizontal, 24.0)
                    .padding(.bottom, 4.0)
                    .padding(.top, 24.0)
                    .onTapGesture {
                        isAddNewGameSheetPresented = true
                    }

                EssentialsListView(games) { boardGame in
                    Text(boardGame.name)
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
                    }
                )
            }
            .sheet(isPresented: $isAddNewGameSheetPresented) {
                ChatAddNewGameView()
            }
        } failureView: { _ in
            EssentialsContentUnavailableView(
                icon: Image(systemName: "wifi.slash"),
                title: "No Connection",
                description: "There was a problem connecting to the internet. Please check your connection and try again."
            ) {
                Task(priority: .userInitiated) { [weak vm] in
                    await vm?.fetchMyCustomGames()
                }
            }
        }
        .task(priority: .userInitiated) { [weak vm] in
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
