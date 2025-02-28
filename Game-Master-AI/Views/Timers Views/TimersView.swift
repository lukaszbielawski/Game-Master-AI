//
//  TimersView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Essentials
import SwiftUI

typealias TimerModel = TimersView.Model

struct TimersView: View {
    @StateObject var vm: TimersViewModel = .init()
    @ObservedObject var tabRouter = TabRouterState.shared
    @ObservedObject var router = RouterState.shared
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0.0) {
                Divider()
                TimerPickerView(geo: geo)
                    .padding(.top, 16)
                Button {
                    EssentialsHapticService.shared.play(.light)
                    vm.createTimer()
                } label: {
                    Text("Start new timer")
                }
                .buttonStyle(EssentialsButtonStyle())
                .disabled(vm.pickerDurationSeconds == 0)
                .animation(.easeInOut(duration: 0.35), value: vm.pickerDurationSeconds)

                EssentialsPlainList($vm.timers) { _, elem in
                    TimerViewListCell(model: elem)
                        .swipeActionDelete(model: elem.wrappedValue) { timerToDelete in
                            vm.deleteTimer(timerToDelete)
                        }
                }
                Spacer()
            }
            .onAppear {
                tabRouter.currentToolbarRoute = .timers

            }
        }
        .environmentObject(vm)
    }
}

extension TimersView {
    struct Model: Hashable, Codable, Identifiable {
        var id: UUID = .init()
        var initialDurationSeconds: Int
    }

    

    
}
