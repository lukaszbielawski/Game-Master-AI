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

    @Published var manualImages: [CGImage] = []
    @Published var currentStep: Int = 0
    @Published var totalStepCount: Int = 1
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var creationStage: GameCreationStage = .ocr
    @Published var cancellables: Set<AnyCancellable> = []

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

        totalPages = manualImages.count
        totalStepCount += manualImages.count
        currentStep += 1
        creationStage = .pageConversion

        Timer.publish(every: CGFloat(15.0 / CGFloat(manualImages.count)), on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if currentPage < totalPages {
                    currentStep += 1
                    currentPage += 1
                } else {
                    cancellables.removeAll()
                }
            }
            .store(in: &cancellables)

        let base64Strings = manualImages.map { $0.toBase64String }
        let areBase64StringsProperlyCreated = base64Strings.allSatisfy { $0 != nil }
        guard areBase64StringsProperlyCreated else {
            print("Base64 creation error \(areBase64StringsProperlyCreated)")
            gameCreatedPublisher.send(completion: .failure(.init(nil)))
            return
        }

        let request = ProcessInstructionRequest(boardGameName: gameName, base64Images: base64Strings.compactMap { $0 })
        let processInstructionResult = await processInstructionAPIService.processInstruction(request: request) { [weak self] chunk in
            guard let self else { return }
            if chunk == "^" {
                if currentPage != totalPages {
                    currentStep += 1
                    currentPage += 1
                }
            }
        }
        switch processInstructionResult {
        case .success(let newSubject):
            creationStage = .finished
            currentStep += 1
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
        guard let selectedPDFManualURL else { return .failure(.other("No PDF file URL")) }
        return .success(textRecognitionService.convertPDFToImages(pdfFileURL: selectedPDFManualURL))
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
