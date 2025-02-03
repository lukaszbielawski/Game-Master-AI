//
//  ChatAddNewGameView+GameNameTextFieldView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import SwiftUI
import Essentials

extension ChatAddNewGameView {
    struct GameNameTextFieldView: View {
        @Binding private var gameName: String
        @State private var onAddGameTapped: () -> Void
        @FocusState.Binding private var isFocused: Bool

        init(gameName: Binding<String>, isFocused: FocusState<Bool>.Binding, onAddGameTapped: @escaping () -> Void) {
            self._gameName = gameName
            self._isFocused = isFocused
            self.onAddGameTapped = onAddGameTapped
        }

        var body: some View {
            VStack(spacing: 16.0) {
                Text("Add New Game")
                    .font(.largeTitle)
                    .padding(.top, 16.0)

                TextField("Enter game name", text: $gameName)
                    .focused($isFocused)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 16.0)

                Button {
                    onAddGameTapped()
                } label: {
                    Text("Continue")
                }
                .buttonStyle(EssentialsBigButtonStyle())
                Spacer()
            }
        }
    }
}
