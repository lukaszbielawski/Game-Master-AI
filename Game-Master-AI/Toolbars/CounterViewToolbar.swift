//
//  CounterViewToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import SwiftUI

struct CounterViewToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Counters")
                .fontWeight(.semibold)
                .transition(.normalOpacityEaseInOut)
        }
    }
}
