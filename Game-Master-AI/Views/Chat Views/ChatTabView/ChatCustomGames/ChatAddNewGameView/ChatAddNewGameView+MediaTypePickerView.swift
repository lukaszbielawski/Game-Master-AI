//
//  ChatAddNewGameView+MediaTypePickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import SwiftUI

extension ChatAddNewGameView {
    struct MediaTypePickerView: View {
        @EnvironmentObject private var vm: ChatAddNewGameViewModel
        @EnvironmentObject private var router: EssentialsRouterState<Route, SheetRoute>

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

        var body: some View {
            VStack(spacing: 16.0) {
                Text("Select Game Manual Source")
                    .font(.title2)
                    .padding(.top, 16.0)
                EssentialsSelectionListView(options: options) { selection in
                    EssentialsHapticService.shared.play(.medium)
                    if selection == options[0] {
                        router.currentRoute = .cameraPickerView(vm)
                        router.currentSheetRoute = .none
                    } else if selection == options[1] {
                        router.currentRoute = .photoPickerView(vm)
                        router.currentSheetRoute = .none
                    } else {
                        router.currentSheetRoute = .pdfFilePickerView(vm)
                    }
                }
                Spacer()
            }
        }
    }
}
