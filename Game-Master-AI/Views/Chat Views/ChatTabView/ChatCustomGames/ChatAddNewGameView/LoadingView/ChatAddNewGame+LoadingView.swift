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

        @State private var gameName: String = ""
        @State private var onAddGameTapped: () -> Void
        @State private var progressFraction: CGFloat = 0.0

        let lines = [
            "Extracting text from your manual",
            "Processing page"
        ]

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

                ProgressView(value: progressFraction, total: 1.0)
                    .colorMultiply(Color.white)
                    .onAppear {}
                HStack(spacing: 8.0) {
                    ProgressView()
                        .font(.callout)
                    Text("Extracting text from your manual")
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
                .disabled(progressFraction != 1.0)
                Spacer()
            }.task(priority: .userInitiated) { [weak vm] in
                await vm?.createBoardGame()
            }
            .modifier(EssentialsAutoHeightSheetModifier(fraction: .constant(0.75)))
        }
    }
}
