//
//  ChatAddNewGameView+PDFFilePickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 06/02/2025.
//

import Essentials
import Foundation
import SwiftUI

extension ChatAddNewGameView {
    struct PDFFilePickerView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel
        @ObservedObject var router = RouterState.shared
        @Environment(\.dismiss) var dismiss

        var body: some View {
            EssentialsPDFFilePickerView(
                selectedPDFFile: $vm.selectedPDFManualURL)
            {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                Task {
                    await MainActor.run {
                        router.currentSheetRoute = .addBoardGameView(vm)
                    }
                }
            }
        }
    }
}
