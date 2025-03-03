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
        @State private var frameHeight: CGFloat?

        let lines = [
            "Extracting text from your manual",
            "Processing page",
            "Completed"
        ]

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

        private var currentLoadingLine: String {
            if currentLineIndex == 0 || currentLineIndex == 2 {
                lines[currentLineIndex]
            } else {
                lines[currentLineIndex] + " \(vm.currentPage)/\(vm.totalPages)"
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
            var sheetHeightFraction = Binding<CGFloat>(
                get: {
                    if let frameHeight {
                        if frameHeight * 0.75 < 852.0 * 0.75 {
                            min(1.0, 0.75 * 852.0 / frameHeight)
                        } else {
                            0.75
                        }
                    } else {
                        0.75
                    }
                },
                set: { _ in

                }
            )

            VStack(spacing: 8.0) {
                Text("Please wait")
                    .font(.title)
                    .fontWeight(.regular)
                    .padding(.top, 16.0)
                Text("Your manual is being processed...")
                    .font(.headline)
                    .fontWeight(.light)

                ProgressView(value: currentProgresFraction, total: 1.0)
                    .colorMultiply(Color.white)
                    .onAppear {}
                HStack(spacing: 8.0) {
                    ProgressView()
                        .font(.callout)
                    Text(currentLoadingLine)
                        .font(.callout)
                        .fontWeight(.light)
                }

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
            .modifier(EssentialsAutoHeightSheetModifier(fraction: sheetHeightFraction))
            .frameAccessor { frameHeight = $0.height }
            .onReceive(vm.gameCreatedPublisher) { boardGameModel in
                router.currentSheetRoute = .none
                router.navigateTo(.chatView(boardGameModel))
            } onFailure: { error in
                EssentialsToastProvider.shared.enqueueToast(EssentialsToast(fromError: error))
                router.currentSheetRoute = .none
            }
        }
    }
}
