//
//  ChatAddNewGameViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Combine
import Essentials
import Foundation
import PhotosUI

@MainActor
final class ChatAddNewGameViewModel: ObservableObject {
    @Published var currentViewPage: ViewPage = .gameNameTextField
    @Published var gameName: String = ""

    @Published var selectedPhotos: [PHPickerResult] = []
    @Published var selectedImages: [CGImage] = []
    @Published var selectedPDFManualURL: URL?

    @Published var retrievedText: EssentialsLoadingState<String> = .initial
    @Published var currentStep: Int = 0
    @Published var totalStepCount: Int = 1
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var creationStage: GameCreationStage = .ocr

    let gameCreatedPublisher = PassthroughSubject<BoardGameModel, Never>()

    let textRecognitionService = EssentialsTextRecognitionService()
    let photoLibraryService = EssentialsPhotoLibraryService()
    let processInstructionAPIService = ProcessInstructionAPIService()
    let subjectsAPIService = EssentialsSubjectsAPIService()

    func createBoardGame() async {
        let result: Result<String, EssentialsTextRecognitionServiceError>
        retrievedText = .loading
        if !selectedPhotos.isEmpty {
            result = await createGameFromSelectedAssets()
        } else if !selectedImages.isEmpty {
            result = await createGameFromCameraPickedImages()
        } else {
            result = await createGameFromPDFManualFile()
        }
        retrievedText <== result
        let manualPages = retrievedText.getValueIfSuccess()?.split(separator: "\u{0C}").count ?? 0
        totalPages = manualPages
        totalStepCount += manualPages
        currentStep += 1
        creationStage = .pageConversion

        if let retrievedTextValue = retrievedText.getValueIfSuccess() {
            let request = ProcessInstructionRequest(boardGameName: gameName, text: retrievedTextValue)
            let result = await processInstructionAPIService.processInstruction(request: request) { [weak self] chunk in
                guard let self else { return }
                print(chunk)
                if chunk == "^" {
                    if currentPage != totalPages {
                        currentStep += 1
                        currentPage += 1
                    }
                }
            }
            switch result {
            case .success(let newSubject):
                creationStage = .finished
                currentStep += 1
                let boardGameModel = BoardGameModel(newSubject)
                gameCreatedPublisher.send(boardGameModel)
            case .failure(let failure):
                print(failure)
            }
        }
    }

    private func createGameFromSelectedAssets() async -> Result<String, EssentialsTextRecognitionServiceError> {
        let imagesResult = await photoLibraryService.loadCGImages(from: selectedPhotos)
            .mapError { EssentialsTextRecognitionServiceError.other($0.localizedDescription) }
        switch imagesResult {
        case .success(let images):
            return await textRecognitionService.recognizeTextsBulk(from: images)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func createGameFromCameraPickedImages() async -> Result<String, EssentialsTextRecognitionServiceError> {
        return await textRecognitionService.recognizeTextsBulk(from: selectedImages)
    }

    private func createGameFromPDFManualFile() async -> Result<String, EssentialsTextRecognitionServiceError> {
        guard let selectedPDFManualURL else { return .failure(.other("No PDF file URL")) }
        return await textRecognitionService.recognizePDFFileText(pdfFileURL: selectedPDFManualURL)
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

    enum GameCreationStage {
        case ocr
        case pageConversion
        case finished
    }
}
