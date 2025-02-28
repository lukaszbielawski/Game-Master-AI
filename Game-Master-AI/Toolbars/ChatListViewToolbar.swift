//
//  ChatListViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 09/02/2025.
//

import SwiftUI

struct ChatListViewToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Board games")
                .fontWeight(.semibold)
                .transition(.normalOpacityEaseInOut)
        }
    }
}
