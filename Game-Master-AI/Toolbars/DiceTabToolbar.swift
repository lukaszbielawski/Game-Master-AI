//
//  DiceTabToolbar.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 09/02/2025.
//

import SwiftUI

struct DiceTabToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Roll a dice")
                .transition(.normalOpacityEaseInOut)
        }
    }
}
