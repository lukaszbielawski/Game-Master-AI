//
//  CounterViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import SwiftUI

struct CounterViewToolbar: ToolbarContent {
    let onTapTopBarTrailingButton: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Counters")
                .transition(.normalOpacityEaseInOut)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                onTapTopBarTrailingButton()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.accentColor)
            }

            .contentShape(Rectangle())
            .fontWeight(.semibold)
            .font(.title2)
            .transition(.normalOpacityEaseInOut)
        }
    }
}
