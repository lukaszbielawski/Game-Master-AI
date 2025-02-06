//
//  ChatAddNewGameViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Foundation
import PhotosUI
import Essentials

final class ChatAddNewGameViewModel: ObservableObject {
    @Published var currentPage: ViewPage = .gameNameTextField
    @Published var gameName: String = ""

    @Published var selectedPhotos: [PHPickerResult] = []
    @Published var selectedImages: [CGImage] = []
    @Published var selectedPDFManualURL: URL?

    let textRecognitionService = EssentialsTextRecognitionService()

    func createBoardGame() async {
        print("selectedPhotos", selectedPhotos.count)
        print("selectedImages", selectedImages.count)
        print("selectedPDFManualURL", selectedPDFManualURL)
//        print("selectedPhotos", selectedPhotos.count)
    }
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
