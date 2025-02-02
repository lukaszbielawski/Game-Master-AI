//
//  ChatAddNewGameViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Foundation

final class ChatAddNewGameViewModel: ObservableObject {
    @Published var currentPage: ChatAddNewGameViewPage = .gameNameTextField
    @Published var gameName: String = ""
}

extension ChatAddNewGameViewModel {
    enum ChatAddNewGameViewPage {
        case gameNameTextField
        case mediaTypePicker

        var presentationDetentFraction: CGFloat {
            switch self {
            case .gameNameTextField:
                0.5
            case .mediaTypePicker:
                0.75
            }
        }
    }
}
