//
//  ChatAddNewGameView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 02/02/2025.
//

import Essentials
import SwiftUI

struct ChatAddNewGameView: View {
    @StateObject var vm: ChatAddNewGameViewModel = .init()
    @FocusState private var isFocused: Bool

    @State private var sheetPresentationDetentFraction: CGFloat = 0.5

    var body: some View {
        ZStack {
            switch vm.currentPage {
            case .gameNameTextField:
                GameNameTextFieldView(
                    gameName: $vm.gameName,
                    isFocused: $isFocused
                ) {
                    vm.currentPage = .mediaTypePicker
                }
            case .mediaTypePicker:
                MediaTypePickerView {}
            }
        }
        .padding()
        .modifier(EssentialsAutoHeightSheetModifier(fraction: $sheetPresentationDetentFraction))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
        .onChange(of: vm.currentPage) { newPage in
            sheetPresentationDetentFraction = newPage.presentationDetentFraction
        }
        .onAppear {
            sheetPresentationDetentFraction = vm.currentPage.presentationDetentFraction
        }
        .environmentObject(vm)
    }
}
