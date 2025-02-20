//
//  TimersViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import SwiftUI

struct TimersViewToolbar: ToolbarContent {
    @Binding var isInEditMode: Bool
    let onTapTopBarTrailingButton: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Timers")
                .transition(.normalOpacityEaseInOut)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                onTapTopBarTrailingButton()
            } label: {
                Image(systemName: isInEditMode ? "arrowshape.turn.up.backward.fill" : "pencil")
                    .foregroundStyle(Color.accentColor)
            }
            .transition(.normalOpacityEaseInOut)
        }
    }
}
