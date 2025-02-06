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
    @EnvironmentObject var toastProvider: EssentialsToastProvider
    @State var searchQuery: String = ""
    @State var isNavigationLinkActivated = false
    @FocusState.Binding var isFocused: Bool
    @EnvironmentObject var router: EssentialsRouterState<Route, SheetRoute>

    var body: some View {
        EssentialsLoadingStateView(vm.games) { games in
            VStack(spacing: 8.0) {
                Text("Board games")
                    .padding(.top, 8.0)
                    .padding(.bottom)
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
                        router.currentSheetRoute = .addBoardGameView
                    }

                EssentialsListView(games) { boardGame in
                    Text(boardGame.name)
                } onCellTaped: { boardGame in
                    isFocused = false
                    router.currentRoute = .chatView(boardGame, toastProvider)
                }
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
        .onTapGesture {
            isFocused = false
        }
        .padding(.bottom, 16.0)
    }
}
