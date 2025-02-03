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
    @StateObject private var chatTabViewModel = ChatTabViewModel()
    @EnvironmentObject private var toastProvider: EssentialsToastProvider
    @EnvironmentObject private var subscriptionState: EssentialsSubscriptionState
    @EnvironmentObject private var colorSchemeState: EssentialsColorSchemeState
    @EnvironmentObject private var router: EssentialsRouterState<Route, SheetRoute>

    var body: some View {
        TabView(selection: $tabNumber) {
            ChatTabView()
                .environmentObject(chatTabViewModel)
                .tabItem { Label("Games", systemImage: "checkerboard.rectangle") }
                .tag(1)
            DicesView()
                .tabItem { Label("Dices", systemImage: "dice.fill") }
                .tag(2)
            EssentialsSettingsView(subscriptionState, colorSchemeState, toastProvider, router: router)
                .tabItem { Label("Settings", systemImage: "gearshape.2.fill") }
                .tag(3)
        }
        .onChange(of: tabNumber) { _ in
            HapticService.shared.play(.medium)
        }
    }
}
