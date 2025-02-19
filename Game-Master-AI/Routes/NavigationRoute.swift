//
//  NavigationRoute.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import Foundation
import PhotosUI
import SwiftUI

enum NavigationRoute: EssentialsNavigationRouteProtocol {
    case chatView(_ boardGameModel: BoardGameModel)
    case photoPickerView(_ vm: ChatAddNewGameViewModel)
    case cameraPickerView(_ vm: ChatAddNewGameViewModel)
    case onboardingView
    case paywallView(hasTrial: Bool)

    var body: some View {
        switch self {
        case .chatView(let boardGameModel):
            ChatView(boardGameModel: boardGameModel)
        case .photoPickerView(let vm):
            ChatAddNewGameView.PhotoPickerView()
                .environmentObject(vm)
        case .cameraPickerView(let vm):
            ChatAddNewGameView.CameraPickerView()
                .environmentObject(vm)
        case .onboardingView:
            OnboardingView()
        case .paywallView(let hasTrial):
            PaywallView(hasTrial: hasTrial)
        }
    }

    var rawValue: Int {
        return switch self {
        case .chatView:
            0
        case .photoPickerView:
            1
        case .cameraPickerView:
            2
        case .onboardingView:
            3
        case .paywallView:
            4
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return switch (lhs, rhs) {
        case (.chatView, .chatView):
            true
        case (.photoPickerView, .photoPickerView):
            true
        case (.cameraPickerView, .cameraPickerView):
            true
        case (.onboardingView, .onboardingView):
            true
        case (.paywallView, .paywallView):
            true
        default:
            false
        }
    }
}

extension NavigationRoute:
    EssentialsOnboardingNavigationRouteDelegate & EssentialsPaywallNavigationRouteDelegate
{
    static func getOnboardingNavigationRoute() -> NavigationRoute {
        .onboardingView
    }

    static func getPaywallNavigationRoute(hasTrial: Bool) -> NavigationRoute {
        .paywallView(hasTrial: hasTrial)
    }
}
