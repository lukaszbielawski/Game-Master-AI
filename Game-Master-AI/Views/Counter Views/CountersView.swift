//
//  CountersView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Essentials
import SwiftUI

typealias CounterModel = CountersView.Model

struct CountersView: View {
    @StateObject var vm: CountersViewModel = .init()
    @ObservedObject var tabRouter = TabRouterState.shared
    @ObservedObject var router = RouterState.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if vm.counters.isEmpty {
                EssentialsContentUnavailableView(
                    icon: Image(systemName: "minus.forwardslash.plus"),
                    title: "No Counters Available",
                    description: "You haven't added any counters yet. Tap the '+' button to create a new one.",
                    hasRetryButton: false
                )
            } else {
                EssentialsPlainList($vm.counters) { _, elem in
                    CounterViewListCell(model: elem)
                        .swipeActionDelete(model: elem.wrappedValue) { elemToDelete in
                            vm.deleteCounter(elemToDelete)
                        }
                }
            }
        }
        .padding(.top, 16)
        .background(Color.backgroundColor, ignoresSafeAreaEdges: .all)
        .onAppear {
            tabRouter.currentToolbarRoute = .counters {
                EssentialsHapticService.shared.play(.medium)
                router.currentSheetRoute = .addCounterView(vm)
            }
        }
    }
}

extension CountersView {
    struct Model: Hashable, Codable, Identifiable {
        var id: UUID = .init()
        var count: Int
        let color: Color
        let name: String
    }
}
