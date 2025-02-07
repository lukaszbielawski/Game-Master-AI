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
            switch vm.currentViewPage {
            case .gameNameTextField:
                GameNameTextFieldView(
                    gameName: $vm.gameName,
                    isFocused: $isFocused
                ) {
                    EssentialsHapticService.shared.play(.medium)
                    vm.currentViewPage = .mediaTypePicker
                }
            case .mediaTypePicker:
                MediaTypePickerView()
            }
        }
        .padding()
        .modifier(EssentialsAutoHeightSheetModifier(fraction: $sheetPresentationDetentFraction))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
        .onChange(of: vm.currentViewPage) { newPage in
            sheetPresentationDetentFraction = newPage.presentationDetentFraction
        }
        .onAppear {
            sheetPresentationDetentFraction = vm.currentViewPage.presentationDetentFraction
        }
        .environmentObject(vm)
    }
}
