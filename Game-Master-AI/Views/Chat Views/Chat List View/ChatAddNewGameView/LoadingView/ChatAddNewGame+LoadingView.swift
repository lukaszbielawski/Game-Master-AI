//
//  ChatAddNewGame+LoadingView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 05/02/2025.
//

import Essentials
import SwiftUI

extension ChatAddNewGameView {
    struct LoadingView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel
        @ObservedObject var router = RouterState.shared

        @State private var gameName: String = ""
        @State private var onAddGameTapped: () -> Void

        @State private var sheetHeightFraction: CGFloat = 1.0

        private var currentLineIndex: Int {
            return switch vm.creationStage {
            case .ocr:
                0
            case .pageConversion:
                1
            case .finished:
                2
            }
        }

        var currentProgresFraction: CGFloat {
            CGFloat(vm.currentStep)
                / CGFloat(vm.totalStepCount)
        }

        public init(onAddGameTapped: @escaping () -> Void) {
            self.onAddGameTapped = onAddGameTapped
        }

        var body: some View {
            ZStack {
                VStack(spacing: 8.0) {
                    Text("Please wait")
                        .font(.title)
                        .fontWeight(.regular)
                        .padding(.top, 16.0)
                    Text("Your rulebook is being processed...")
                        .font(.headline)
                        .fontWeight(.light)

                    ProgressView(value: currentProgresFraction, total: 1.0)
                        .colorMultiply(Color.white)
                        .onAppear {}
                    HStack(alignment: .top, spacing: 8.0) {
                        ProgressView()
                            .font(.callout)
                        Text(vm.currentLoadingMessage)
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .fontWeight(.light)
                    }
                    .padding(.horizontal, 16.0)
                    Spacer()

                    MemoryView()

                    Button {
                        onAddGameTapped()
                    } label: {
                        Text("Continue")
                    }
                    .buttonStyle(EssentialsBigButtonStyle())
                    .disabled(currentProgresFraction != 1.0)
                    Spacer()
                }.task(priority: .userInitiated) { [weak vm] in
                    await vm?.createBoardGame()
                }
                .modifier(EssentialsAutoHeightSheetModifier(fraction: $sheetHeightFraction))
            }

            .essentialsSheetHeight($sheetHeightFraction, desiredFraction: 0.75)
            .onReceive(vm.gameCreatedPublisher) { boardGameModel in
                router.currentSheetRoute = .none
                router.navigateTo(.chatView(boardGameModel))
            } onFailure: { error in
                EssentialsToastProvider.shared.enqueueToast(EssentialsToast(fromError: error))
                router.currentSheetRoute = .none
            }
            .interactiveDismissDisabled()
        }
    }
}
