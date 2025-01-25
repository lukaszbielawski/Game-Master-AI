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
    @State private var tabNumber: Int = 1
    @ObservedObject private var chatTabViewModel = ChatTabViewModel()

    var body: some View {
        TabView(selection: $tabNumber) {
            ChatTabView()
                .environmentObject(chatTabViewModel)
                .tabItem { Label("Games", systemImage: "checkerboard.rectangle") }
                .tag(1)
            DicesView()
                .tabItem { Label("Dices", systemImage: "dice.fill") }
                .tag(2)
            EssentialsSettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.2.fill") }
                .tag(3)
        }
        .onChange(of: tabNumber) { _ in
            HapticService.shared.play(.medium)
        }
    }
}
