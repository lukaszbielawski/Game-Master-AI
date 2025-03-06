//
//  ChatAddNewGameView+PhotoPickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import SwiftUI

extension ChatAddNewGameView {
    struct PhotoPickerView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel
        @ObservedObject var router = RouterState.shared

        @Environment(\.dismiss) var dismiss

        var body: some View {
            EssentialsPhotoPicker(selectedPhotos: $vm.selectedPhotos) {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                dismiss()
                router.currentSheetRoute = .addBoardGameView(vm)
            }
            .ignoresSafeArea(.all)
        }
    }
}
