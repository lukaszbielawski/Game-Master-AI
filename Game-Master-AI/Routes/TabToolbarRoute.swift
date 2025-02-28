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
    case chatListView
    case counters
    case timers

    var toolbarBody: some ToolbarContent {
        switch self {
        case .diceTab:
            DiceTabToolbar()
        case .chatListView:
            ChatListViewToolbar()
        case .counters:
            CounterViewToolbar()
        case .timers:
            TimersViewToolbar()
        }
    }
}
