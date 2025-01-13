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
    let api = ChatAPI()

    var body: some Scene {
        WindowGroup {
            EssentialsApp {
                ContentView()
                    .environmentObject(api)
            }
        }
    }
}
