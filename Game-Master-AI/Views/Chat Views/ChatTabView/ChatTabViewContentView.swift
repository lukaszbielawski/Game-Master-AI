//
//  ChatTabViewContentView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import SwiftUI

struct ChatTabViewContentView: View {
    @EnvironmentObject var vm: ChatTabViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        ZStack {
            TabView(selection: $vm.selectedTab) {
                ChatListView(isFocused: $isFocused)
                    .tag(0)
                ChatListView(isFocused: $isFocused)
                    .tag(1)
            }
            .onChange(of: vm.selectedTab) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if isFocused {
                        isFocused = false
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.35), value: vm.selectedTab)
        }
    }
}
