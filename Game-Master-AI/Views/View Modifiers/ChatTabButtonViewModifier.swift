//
//  ChatTabButtonViewModifier.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import SwiftUI

struct ChatTabButtonViewModifier: ViewModifier {
    @EnvironmentObject var vm: ChatTabViewModel
    let tabNumber: Int

    func body(content: Content) -> some View {
            content
            .fontWeight(.semibold)
            .padding()
            .foregroundColor(Color.white)
            .colorMultiply(vm.selectedTab == tabNumber ? Color(.tint) : .gray)
            .animation(.easeInOut(duration: 0.35), value: vm.selectedTab)
    }
}
