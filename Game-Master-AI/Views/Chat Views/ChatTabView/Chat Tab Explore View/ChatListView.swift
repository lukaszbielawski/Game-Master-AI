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
    @State var searchQuery: String = ""
    @State var isNavigationLinkActivated = false
    @FocusState.Binding var isFocused: Bool
    @State var boardGameSubject = CurrentValueSubject<String?, Never>(nil)

    var body: some View {
        VStack(spacing: 8.0) {
            EssentialsSearchBarView(searchText: $searchQuery, isFocused: $isFocused)
                .onChange(of: searchQuery) { newValue in
                    vm.searchQueryChanged(newValue: newValue)
                }
            EssentialsListView(vm.filteredGames) { boardGame in
                Text(boardGame)
                    .foregroundStyle(Color(.accent))
            } onCellTaped: { boardGame in
                isFocused = false
                boardGameSubject.send(boardGame)
            }

            NavigationLink(
                destination:
                EssentialsLazyView {
                    ChatView(boardGame: boardGameSubject.value ?? "")
                        .onDisappear {
                            boardGameSubject.send(nil)
                        }
                },
                isActive: $isNavigationLinkActivated, label: {
                    EmptyView()
                })
        }
        .onReceive(boardGameSubject) { value in
            print("value", value)
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
