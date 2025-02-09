//
//  TabRoute.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/02/2025.
//

import Essentials
import SwiftUI

enum TabRoute: EssentialsTabRouteProtocol {
    case games
    case dice
    case settings

    static var defaultTabRoute: TabRoute = .games

    var body: some View {
        switch self {
        case .games:
            GamesView()
        case .dice:
            DicesView()
        case .settings:
            EssentialsSettingsView(navigationRoute: NavigationRoute.self,
                                   sheetRoute: SheetRoute.self,
                                   tabRoute: TabRoute.self,
                                   tabToolbarRoute: TabToolbarRoute.self)
        }
    }

    @ViewBuilder
    var routeTabItem: some View {
        switch self {
        case .games:
            Label("Games", systemImage: "checkerboard.rectangle")
        case .dice:
            Label("Dices", systemImage: "dice.fill")
        case .settings:
            Label("Settings", systemImage: "gearshape.2.fill")
        }
    }
}
