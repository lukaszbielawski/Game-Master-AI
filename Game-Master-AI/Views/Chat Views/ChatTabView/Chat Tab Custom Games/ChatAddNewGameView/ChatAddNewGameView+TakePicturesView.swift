//
//  ChatAddNewGameView+TakePicturesView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import SwiftUI
import Essentials

extension ChatAddNewGameView {
    struct TakePicturesView: View {
        @EnvironmentObject var vm: ChatAddNewGameViewModel

        var body: some View {
            EssentialsPhotoPicker(selectedPhotos: $vm.selectedPhotos)
        }
    }
}
