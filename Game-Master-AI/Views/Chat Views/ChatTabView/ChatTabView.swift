//
//  ChatTabView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Essentials
import Foundation
import SwiftUI

struct ChatTabView: View {
    @EnvironmentObject var vm: ChatTabViewModel

    var body: some View {
        VStack(spacing: 16) {
            ChatTabViewTabs()
            ChatTabViewContentView()
        }
        .background(Color(.background))
    }
}

struct ChatTabViewTabs: View {
    @EnvironmentObject var vm: ChatTabViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Capsule(style: .circular)
                    .fill(Color(.accent))
                    .padding(.horizontal)
                    .frame(width: geo.size.width / 2)
                    .offset(x: vm.selectedTab == 0 ? 0 : geo.size.width / 2)
                    .animation(.easeInOut, value: vm.selectedTab)
                HStack(spacing: 0) {
                    Button(action: {
                        vm.selectedTab = 0
                    }) {
                        Text("Explore")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .modifier(ChatTabButtonViewModifier(tabNumber: 0))
                    }
                    
                    Button(action: {
                        vm.selectedTab = 1
                    }) {
                        Text("Custom Games")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .modifier(ChatTabButtonViewModifier(tabNumber: 1))
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 56)
    }

}
