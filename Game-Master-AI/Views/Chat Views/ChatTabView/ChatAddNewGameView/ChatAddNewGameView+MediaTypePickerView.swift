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
        @EnvironmentObject private var router: RouterState

        let options: [EssentialsSelectionListView.Model] = [
            .init(
                title: "Take pictures",
                description: "Ensure good lighting and sharpness for better text recognition.",
                image: Image(systemName: "camera.fill")
            ),
            .init(
                title: "Photo library",
                description: "Pick bright and sharp photos of the game manual.",
                image: Image(systemName: "photo.fill.on.rectangle.fill")
            ),
            .init(
                title: "Select PDF file",
                description: "Get the best quality and accuracy.",
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
                        router.navigateTo(.cameraPickerView(vm))
                        router.currentSheetRoute = .none
                    } else if selection == options[1] {
                        router.navigateTo(.photoPickerView(vm))
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
