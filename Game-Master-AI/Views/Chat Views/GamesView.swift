//
//  GamesView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Essentials
import Foundation
import SwiftUI

struct GamesView: View {
    @EnvironmentObject var vm: ChatTabViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        ChatListView(isFocused: $isFocused)
            .background(Color(.background))
    }
}
