//
//  ChatListViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 09/02/2025.
//

import SwiftUI

struct ChatListViewToolbar: ToolbarContent {
    @Binding var isInEditMode: Bool
    let onTapTopBarTrailingButton: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Board games")
                .transition(.opacity.animation(.easeInOut(duration: 0.35)))
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                onTapTopBarTrailingButton()
            } label: {
                Image(systemName: isInEditMode ? "arrowshape.turn.up.backward.fill" : "pencil")
                    .foregroundStyle(Color.accentColor)
            }
            .transition(.opacity.animation(.easeInOut(duration: 0.35)))
        }
    }
}
