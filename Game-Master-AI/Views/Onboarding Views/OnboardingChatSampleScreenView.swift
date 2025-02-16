//
//  OnboardingChatSampleScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 15/02/2025.
//

import SwiftUI

struct OnboardingChatSampleScreenView: View {
    @EnvironmentObject var vm: OnboardingViewModel
    @State private var isTitleShown: Bool = false

    var body: some View {
        VStack {
            Text("Try me!")
                .font(.title)
                .opacity(isTitleShown ? 1.0 : 0.0)
            OnboardingSampleChatView {
                withAnimation {
                    vm.isBackButtonDisabled = true
                    vm.currentScreenContinueButtonState = .visible
                }
            }
            .opacity(isTitleShown ? 1.0 : 0.0)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeInOut(duration: 1.0)) {
                isTitleShown = true
            }
        }
        .padding(.bottom, 8)
    }
}
