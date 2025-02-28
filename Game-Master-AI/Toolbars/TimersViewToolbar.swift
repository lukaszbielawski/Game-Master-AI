//
//  TimersViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import SwiftUI

struct TimersViewToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Timers")
                .fontWeight(.semibold)
                .transition(.normalOpacityEaseInOut)
        }
    }
}
