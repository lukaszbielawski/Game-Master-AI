//
//  ChatTabExploreViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Combine
import Essentials
import Foundation
import SwiftUI

final class ChatTabExploreViewModel: ObservableObject {
    @Published private(set) var games: [String] = []
    @Published private(set) var filteredGames: [String] = []
    private let searchQuerySubject = PassthroughSubject<String, Never>()

    private var cancellables: Set<AnyCancellable> = []

    private let gameFetchService = TextParserService()
    private lazy var searchService: TrieSearchService = .init(dictionary: games)

    private let fileName: String = "board_games"

    init() {
        self.games = fetchAllGames()
        self.filteredGames = games
        setupSubscription()
    }

    func searchQueryChanged(newValue: String) {
        searchQuerySubject.send(newValue)
    }

    private func setupSubscription() {
        searchQuerySubject
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .debounce(for: .seconds(0.35), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.search(query: value)
            }
            .store(in: &cancellables)
    }

    private func fetchAllGames() -> [String] {
        switch gameFetchService.readFileLines(fileName: "board_games") {
        case .success(let games):
            return games
        case .failure(let error):
            debugPrint(error)
            return []
        }
    }

    private func search(query: String) {
        filteredGames = searchService.search(prefix: query)
    }
}
