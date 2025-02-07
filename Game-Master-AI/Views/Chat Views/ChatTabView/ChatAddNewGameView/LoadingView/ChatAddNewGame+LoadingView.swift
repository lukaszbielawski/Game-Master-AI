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
        @EnvironmentObject var toastProvider: EssentialsToastProvider
        @EnvironmentObject var router: EssentialsRouterState<Route, SheetRoute>

        @State private var gameName: String = ""
        @State private var onAddGameTapped: () -> Void

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
            .onReceive(vm.gameCreatedPublisher) { boardGameModel in
                router.currentSheetRoute = .none
                router.currentRoute = .chatView(boardGameModel, toastProvider)
            }
            .modifier(EssentialsAutoHeightSheetModifier(fraction: .constant(0.75)))
        }
    }
}
