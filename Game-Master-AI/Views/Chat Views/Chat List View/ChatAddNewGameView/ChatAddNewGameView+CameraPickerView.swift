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
        @ObservedObject var router = RouterState.shared
        @Environment(\.dismiss) var dismiss
        @ObservedObject var subscriptionState = EssentialsSubscriptionState.shared

        var maxPhotos: Int { subscriptionState.isActive ? 40 : 10 }

        var body: some View {
            EssentialsCameraPicker(
                navigationRouterType: NavigationRoute.self,
                sheetRouterType: SheetRoute.self,
                toolbarRouterType: TabToolbarRoute.self,
                selectedImages: $vm.selectedImages,
                title: "Board Game Manual Pictures",
                maxPhotos: maxPhotos)
            {
                dismiss()
                router.currentSheetRoute = .addBoardGameLoadingView(vm: vm)
            } onCancel: {
                dismiss()
                router.currentSheetRoute = .addBoardGameView(vm)
            } leftLeadingView: { vm in
                Text("\(vm.capturedCGImages.count) pages\n(max \(maxPhotos))")
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
