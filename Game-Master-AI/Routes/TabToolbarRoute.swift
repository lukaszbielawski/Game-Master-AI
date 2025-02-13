//
//  TabToolbarRoute.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/02/2025.
//

import Essentials
import SwiftUI

enum TabToolbarRoute: EssentialsTabToolbarRouteProtocol {
    case diceTab
    case chatListView(isInEditMode: Binding<Bool>, onTapTopBarTrailingButton: () -> ())

    var toolbarBody: some ToolbarContent {
        switch self {
        case .diceTab:
            DiceTabToolbar()
        case .chatListView(let isInEditMode, let onTapTopBarTrailingButton):
            ChatListViewToolbar(isInEditMode: isInEditMode, onTapTopBarTrailingButton: onTapTopBarTrailingButton)
        }
    }
}
