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
        @EnvironmentObject var router: EssentialsRouterState<Route, SheetRoute>
        @Environment(\.dismiss) var dismiss

        var body: some View {
            EssentialsPhotoPicker(selectedPhotos: $vm.selectedPhotos) {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                dismiss()
            }
            .ignoresSafeArea(.all)
            .toolbar(.hidden)
        }
    }
}
