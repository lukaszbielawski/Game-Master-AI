//
//  ChatAddNewGameView+CameraPickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 05/02/2025.
//

import Foundation
import Essentials
import SwiftUI
import AVFoundation

extension ChatAddNewGameView {
    struct CameraPickerView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel
        @EnvironmentObject var router: EssentialsRouterState<Route, SheetRoute>
        @Environment(\.dismiss) var dismiss

        var body: some View {
            EssentialsCameraPicker(selectedImages: $vm.selectedImages) {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                dismiss()
            }
        }
    }
}
