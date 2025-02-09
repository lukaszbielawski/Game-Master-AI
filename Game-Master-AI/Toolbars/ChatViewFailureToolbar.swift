//
//  ChatViewFailureToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 09/02/2025.
//

import SwiftUI

struct ChatViewFailureToolbar: ToolbarContent {
    let onTapTopBarLeadingButton: () -> ()

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                onTapTopBarLeadingButton()
            }) {
                Image(systemName: "arrow.uturn.backward")
            }
        }
        ToolbarItem(placement: .principal) {
            Text("Error loading session")
        }
    }
}
