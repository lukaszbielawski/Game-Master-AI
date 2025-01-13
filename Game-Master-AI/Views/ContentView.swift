//
//  ContentView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/01/2025.
//

import Essentials
import StoreKit
import SwiftUI

struct ContentView: View {
    @State var textField: String = "Empty"

    var body: some View {
        TabView {
            GamesView()
                .tabItem { Label("Games", systemImage: "checkerboard.rectangle") }
            DicesView()
                .tabItem { Label("Dices", systemImage: "dice.fill") }
            EssentialsSettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.2.fill") }
        }
    }
}
