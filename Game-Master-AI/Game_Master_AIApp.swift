//
//  Game_Master_AIApp.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/01/2025.
//

import Essentials
import StoreKit
import SwiftUI

typealias RouterState = EssentialsRouterState<NavigationRoute, SheetRoute>
typealias TabRouterState = EssentialsTabRouterState<TabRoute, TabToolbarRoute>

@main
struct Game_Master_AIApp: App {
    var body: some Scene {
        WindowGroup {
            EssentialsApp {
                EssentialsRouter(navigationRouteType: NavigationRoute.self,
                                 sheetRouteType: SheetRoute.self)
                {
                    EssentialsTabRouter(tabRouteType: TabRoute.self, tabToolbarRouteType: TabToolbarRoute.self)
                }
            }
        }
    }
}
