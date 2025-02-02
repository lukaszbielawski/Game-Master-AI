//
//  ChatAddNewGameView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Essentials
import SwiftUI

struct ChatAddNewGameView: View {
    @StateObject private var vm: ChatAddNewGameViewModel = .init()
    @FocusState private var isFocused: Bool

    @State private var sheetPresentationDetentFraction: CGFloat = 0.5

    var body: some View {
        ZStack {
            switch vm.currentPage {
            case .gameNameTextField:
                ChatAddNewGameViewGameNameTextFieldView(
                    gameName: $vm.gameName,
                    isFocused: $isFocused
                ) {
                    vm.currentPage = .mediaTypePicker
                }
//                .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.35)))
            case .mediaTypePicker:
                ChatAddNewGameViewMediaTypePickerView {}
//                    .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.35)))
            }
        }
        .padding()
        .environmentObject(vm)
        .modifier(EssentialsAutoHeightSheetModifier(fraction: $sheetPresentationDetentFraction))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
        .onChange(of: vm.currentPage) { newPage in
            sheetPresentationDetentFraction = newPage.presentationDetentFraction
        }
        .onAppear {
            sheetPresentationDetentFraction = vm.currentPage.presentationDetentFraction
        }
    }
}

extension ChatAddNewGameView {
    private struct ChatAddNewGameViewGameNameTextFieldView: View {
        @Binding private var gameName: String
        @State private var onAddGameTapped: () -> Void
        @FocusState.Binding private var isFocused: Bool

        fileprivate init(gameName: Binding<String>, isFocused: FocusState<Bool>.Binding, onAddGameTapped: @escaping () -> Void) {
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

    private struct ChatAddNewGameViewMediaTypePickerView: View {
        @State private var completion: () -> Void
        let options: [EssentialsSelectionListView.Model] = [
            .init(
                title: "Take pictures",
                description: "Capture images of the game manual",
                image: Image(systemName: "camera.fill")
            ),
            .init(
                title: "Photo library",
                description: "Select images of the game instruction",
                image: Image(systemName: "photo.fill.on.rectangle.fill")
            ),
            .init(
                title: "Select PDF file",
                description: "Choose PDF file of the game manual",
                image: Image(systemName: "doc.text.fill")
            )
        ]

        fileprivate init(completion: @escaping () -> Void) {
            self.completion = completion
        }

        var body: some View {
            VStack(spacing: 16.0) {
                Text("Select Game Manual Source")
                    .font(.title2)
                    .padding(.top, 16.0)
                EssentialsSelectionListView(options: options) { selection in
                    print(selection)
                }
                Spacer()
            }
        }
    }
}
