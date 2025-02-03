//
//  ChatAddNewGameViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Foundation
import PhotosUI

final class ChatAddNewGameViewModel: ObservableObject {
    @Published var currentPage: ViewPage = .gameNameTextField
    @Published var gameName: String = ""

    @Published var selectedPhotos: [PHPickerResult] = []
}

extension ChatAddNewGameViewModel {
    enum ViewPage {
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
