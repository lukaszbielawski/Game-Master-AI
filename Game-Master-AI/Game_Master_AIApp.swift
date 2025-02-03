//
//  Game_Master_AIApp.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/01/2025.
//

import Essentials
import StoreKit
import SwiftUI

@main
struct Game_Master_AIApp: App {
    var body: some Scene {
        WindowGroup {
            EssentialsApp {
                EssentialsRouter(routeType: Route.self, sheetRouteType: SheetRoute.self) {
                    ContentView()
                }
            }
        }
    }
}
