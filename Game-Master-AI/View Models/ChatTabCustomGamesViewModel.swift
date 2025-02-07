//
//  ChatTabCustomGamesViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Combine
import Essentials
import Foundation
import SwiftUI

@MainActor
final class ChatTabCustomGamesViewModel: ObservableObject {
    @Published var games: EssentialsLoadingState<[BoardGameModel]> = .initial
    @Published private(set) var filterPredicate: ((BoardGameModel) throws -> Bool)? = nil
    private let searchQuerySubject = PassthroughSubject<String, Never>()
    @Published var remainingGamesThisMonth: EssentialsLoadingState<Int> = .success(10)

    private var cancellables: Set<AnyCancellable> = []

    private let boardGameAPI = EssentialsSubjectsAPIService()

    private let fileName: String = "board_games"

    func searchQueryChanged(newValue: String) {
        searchQuerySubject.send(newValue)
    }

    func deleteBoardGame(_ boardGame: BoardGameModel) {
        games.removeIfSuccess(boardGame)
    }

    init() {
        searchQuerySubject
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }

    func fetchMyCustomGames() async {
        games = .loading
        switch await boardGameAPI.getMySubjects() {
        case .success(let data):
            games = .success(data.map { .init($0) }.sorted(by: { $0.creationTimestamp > $1.creationTimestamp }))
        case .failure(let error):
            print(error)
            games = .failure(error: error)
        }
    }

    private func search(query: String) {
        if query.isEmpty || query == " " {
            filterPredicate = .none
        } else {
            filterPredicate = { boardGameModel in
                boardGameModel.name.lowercased().contains(query.lowercased())
            }
        }
    }
}
