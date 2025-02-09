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
    @FocusState var isFocused: Bool
    @EnvironmentObject var subscriptionState: EssentialsSubscriptionState

    var body: some View {
        ChatListView(subscriptionState: subscriptionState, isFocused: $isFocused)
            .background(Color(.background))
    }
}
