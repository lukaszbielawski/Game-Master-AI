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
    @Published private(set) var filteredGames: [BoardGameModel] = []
    private let searchQuerySubject = PassthroughSubject<String, Never>()

    private var cancellables: Set<AnyCancellable> = []

//    private let gameFetchService = TextParserService()
//    private lazy var searchService: TrieSearchService = .init(dictionary: games)
    private let boardGameAPI = EssentialsSubjectsAPIService()

    private let fileName: String = "board_games"

    func searchQueryChanged(newValue: String) {
        searchQuerySubject.send(newValue)
    }

//    private func setupSubscription() {
//        searchQuerySubject
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .debounce(for: .seconds(0.35), scheduler: DispatchQueue.main)
//            .sink { [weak self] value in
//                self?.search(query: value)
//            }
//            .store(in: &cancellables)
//    }

    func fetchMyCustomGames() async {
        games = .loading
        switch await boardGameAPI.getMySubjects() {
        case .success(let data):
            games = .success(data.map { .init($0) })
        case .failure(let error):
            print(error)
            games = .failure(error: error)
        }
    }

//    private func search(query: String) {
//        filteredGames = games.filter { searchService.search(prefix: query).contains { $0.name } }
//    }
}
