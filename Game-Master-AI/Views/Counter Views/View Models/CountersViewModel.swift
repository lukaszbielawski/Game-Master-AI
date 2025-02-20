//
//  CountersViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Essentials
import SwiftUI

final class CountersViewModel: ObservableObject {
    @Published var counters: [CounterModel] = [] {
        willSet {
            Task { @MainActor in
                countersStorage = newValue
            }
        }
    }

    @EssentialsAppStorage("counters") private var countersStorage: [CounterModel]?

    @Published var counterName: String = "Counter 1"
    @Published var counterColor: Color = .accent

    @Published private var initialCount: Int = 10

    init() {
        self.counters = countersStorage ?? []
    }

    let router = RouterState.shared

    @Published var initialCountTextField: String = "10" {
        willSet {
            initialCount = Int(newValue) ?? 0
        }
    }

    func createCounter() {
        let newCounter = CounterModel(count: initialCount, color: counterColor, name: counterName)
        counters.append(newCounter)
        cleanForm()
        router.currentSheetRoute = .none
    }

    func cleanForm() {
        counterName = "Counter \(counters.count + 1)"
    }

    func deleteCounter(_ model: CounterModel) {
        if let indexToRemove = counters.firstIndex(where: { $0.id == model.id }) {
            counters.remove(at: indexToRemove)
        }
    }
}
