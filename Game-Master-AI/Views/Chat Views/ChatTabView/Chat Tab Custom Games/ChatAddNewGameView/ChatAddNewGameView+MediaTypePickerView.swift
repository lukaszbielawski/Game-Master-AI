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
        @State private var completion: () -> Void
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

        init(completion: @escaping () -> Void) {
            self.completion = completion
        }

        var body: some View {
            VStack(spacing: 16.0) {
                Text("Select Game Manual Source")
                    .font(.title2)
                    .padding(.top, 16.0)
                EssentialsSelectionListView(options: options) { _ in
                    router.currentRoute = .photoPickerView(vm)
                    router.currentSheetRoute = .none
                }
                Spacer()
            }
        }
    }
}
