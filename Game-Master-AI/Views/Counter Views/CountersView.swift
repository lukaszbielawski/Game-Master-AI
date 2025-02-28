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
//                List {
//                    ForEach(Array($vm.counters.enumerated()), id: \.0) { index, $counter in
//                        VStack(spacing: 0.0) {
//                            Divider()
//                            CounterViewListCell(model: $counter) { counterToDelete in
//                                vm.deleteCounter(counterToDelete)
//                            }
//                            .contentShape(Rectangle())
//                            if index == vm.counters.count - 1 {
//                                Divider()
//                            }
//                        }
//                    }
//
//                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                }
//                .listStyle(.plain)
//
//                .listRowSeparator(.hidden)
                EssentialsPlainList($vm.counters) { _, elem in
                    CounterViewListCell(model: elem)
                        .swipeActionDelete(model: elem.wrappedValue) { elemToDelete in
                            vm.deleteCounter(elemToDelete)
                        }
                }
            }
        }
        .padding(.top, 16)
        .onAppear {
            tabRouter.currentToolbarRoute
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
