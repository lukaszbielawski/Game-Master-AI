//
//  ChatListViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Combine
import Essentials
import Foundation
import SwiftUI

@MainActor
final class ChatListViewModel: ObservableObject {
    @Published var games: EssentialsLoadingState<[BoardGameModel], EssentialsSubjectsAPIService.Error> = .initial
    @Published private(set) var filterPredicate: ((BoardGameModel) throws -> Bool)? = nil
    private let searchQuerySubject = PassthroughSubject<String, Never>()
    @Published private(set) var remainingUserUsages: EssentialsLoadingState<[EssentialsUserUsageDTO], EssentialsDevicesAPIService.Error> = .initial

    private var cancellables: Set<AnyCancellable> = []

    private let boardGameAPI = EssentialsSubjectsAPIService()
    private let deviceAPI = EssentialsDevicesAPIService()
    private let subscriptionState = EssentialsSubscriptionState.shared

    private let toastProvider = EssentialsToastProvider.shared

    func searchQueryChanged(newValue: String) {
        searchQuerySubject.send(newValue)
    }

    func deleteBoardGame(_ boardGame: BoardGameModel) async {
        switch await boardGameAPI.deleteSubject(subjectId: boardGame.id) {
        case .success(let success):
            games.removeIfSuccess(boardGame)
        case .failure(let failure):
            toastProvider.enqueueToast(.init(fromError: failure))
        }

    }

    var remainingGameCreations: Int {
        if subscriptionState.isActive {
            guard let monthlyLimitMessagesDTO = remainingUserUsages.getValueIfSuccess()?
                .first(where: { $0.tier == TierType.monthlyLimitNewGames.tierValue }) else { return 0 }
            return monthlyLimitMessagesDTO.remainingUses
        } else {
            guard let monthlyLimitMessagesDTO = remainingUserUsages.getValueIfSuccess()?
                .first(where: { $0.tier == TierType.freeUsesNewGames.tierValue }) else { return 0 }
            return monthlyLimitMessagesDTO.remainingUses
        }
    }

    var canAddGame: Bool {
        print("Remaining games \(remainingGameCreations)")
        return remainingGameCreations > 0
    }

    init() {
        Task(priority: .userInitiated) {
            await fetchMyCustomGames()
            await fetchAllMyRemainingUses()
        }
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

    func fetchAllMyRemainingUses() async {
        remainingUserUsages = .loading
        switch await deviceAPI.getAllUserUses() {
        case .success(let response):
            remainingUserUsages = .success(response.userUses)
        case .failure(let error):
            print(error)
            remainingUserUsages = .failure(error: error)
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
