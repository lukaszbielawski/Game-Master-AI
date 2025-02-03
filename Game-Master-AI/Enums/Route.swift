//
//  Route.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import Foundation
import PhotosUI
import SwiftUI

enum Route: EssentialsRouteProtocol {
    case chatView(_ boardGameModel: BoardGameModel, _ toastProvider: EssentialsToastProvider)
    case photoPickerView(_ vm: ChatAddNewGameViewModel)

    var body: some View {
        switch self {
        case .chatView(let boardGameModel, let toastProvider):
            ChatView(boardGameModel: boardGameModel, toastProvider: toastProvider)
        case .photoPickerView(let vm):
            ChatAddNewGameView.TakePicturesView()
                .environmentObject(vm)
        }
    }

    var rawValue: Int {
        return switch self {
        case .chatView:
            0
        case .photoPickerView:
            1
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    static func == (lhs: Route, rhs: Route) -> Bool {
        return switch (lhs, rhs) {
        case (.chatView, .chatView):
            true
        case (.photoPickerView, .photoPickerView):
            true
        default:
            false
        }
    }
}
