//
//  ChatAddNewGameView+CameraPickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 05/02/2025.
//

import AVFoundation
import Essentials
import Foundation
import SwiftUI

extension ChatAddNewGameView {
    struct CameraPickerView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel
        @EnvironmentObject var router: EssentialsRouterState<Route, SheetRoute>
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var subscriptionState: EssentialsSubscriptionState

        var maxPhotos: Int { subscriptionState.isActive ? 40 : 10 }

        var body: some View {
            EssentialsCameraPicker(selectedImages: $vm.selectedImages,
                                   title: "Board Game Manual Pictures",
                                   maxPhotos: maxPhotos)
            {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                dismiss()
            } leftLeadingView: { vm in
                Text("\(vm.capturedCGImages.count) pages\n(max \(maxPhotos))")
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
