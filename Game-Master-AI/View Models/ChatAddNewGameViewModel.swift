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
import SwiftUI

@MainActor
final class ChatAddNewGameViewModel: ObservableObject {
    @Published var currentViewPage: ViewPage = .gameNameTextField
    @Published var gameName: String = ""

    @Published var selectedPhotos: [PHPickerResult] = []
    @Published var selectedImages: [CGImage] = []
    @Published var selectedPDFManualURL: URL?

    @Published var manualImages: [CGImage] = []
    @Published var currentStep: Int = 1
    @Published var totalStepCount: Int = 4
    @Published var creationStage: GameCreationStage = .ocr

    @Published var currentLoadingMessage: String = "Extracting text from your manual"

    let gameCreatedPublisher = PassthroughSubject<BoardGameModel, ProcessInstructionAPIService.Error>()
    let toastProvider = EssentialsToastProvider.shared

    let textRecognitionService = EssentialsTextRecognitionService()
    let photoLibraryService = EssentialsPhotoLibraryService()
    let processInstructionAPIService = ProcessInstructionAPIService()
    let subjectsAPIService = EssentialsSubjectsAPIService()

    func createBoardGame() async {
        let result: Result<[CGImage], EssentialsTextRecognitionServiceError>
        if !selectedPhotos.isEmpty {
            result = await createGameFromSelectedAssets()
        } else if !selectedImages.isEmpty {
            result = .success(selectedImages)
        } else {
            result = await createGameFromPDFManualFile()
        }
        switch result {
        case .success(let images):
            manualImages = images
        case .failure(let failure):
            print(failure)
            gameCreatedPublisher.send(completion: .failure(.init(nil)))
            return
        }

        creationStage = .pageConversion

        let base64Strings = await withTaskGroup(of: String?.self, returning: [String?].self) { [weak self] group in
            guard let self else { return [nil] }
            manualImages.forEach { image in
                group.addTask(priority: .utility) {
                    await image.toBase64String()
                }
            }
            var base64EncodedImages: [String?] = []
            for await base64EncodedImage in group {
                base64EncodedImages.append(base64EncodedImage)
            }
            return base64EncodedImages
        }

        let areBase64StringsProperlyCreated = base64Strings.allSatisfy { $0 != nil }
        guard areBase64StringsProperlyCreated else {
            print("Base64 creation error \(areBase64StringsProperlyCreated)")
            gameCreatedPublisher.send(completion: .failure(.init(nil)))
            return
        }

        let request = ProcessInstructionRequest(boardGameName: gameName, base64Images: base64Strings.compactMap { $0 })
        let processInstructionResult = await processInstructionAPIService.processInstruction(request: request) { [weak self] userDestinedMessage in
            guard let self else { return }
            withAnimation {
                self.currentLoadingMessage = userDestinedMessage
            }
            currentStep += 1
        }
        switch processInstructionResult {
        case .success(let newSubject):
            creationStage = .finished
            let boardGameModel = BoardGameModel(newSubject)
            gameCreatedPublisher.send(boardGameModel)
        case .failure(let failure):
            gameCreatedPublisher.send(completion: .failure(failure))
        }
    }

    private func createGameFromSelectedAssets() async -> Result<[CGImage], EssentialsTextRecognitionServiceError> {
        return await photoLibraryService.loadCGImages(from: selectedPhotos)
            .mapError { EssentialsTextRecognitionServiceError.other($0.localizedDescription) }
    }

    private func createGameFromPDFManualFile() async -> Result<[CGImage], EssentialsTextRecognitionServiceError> {
        guard let selectedPDFManualURL = selectedPDFManualURL else { return .failure(.other("No PDF file URL")) }

        return await textRecognitionService.convertPDFToImages(pdfFileURL: selectedPDFManualURL)
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
