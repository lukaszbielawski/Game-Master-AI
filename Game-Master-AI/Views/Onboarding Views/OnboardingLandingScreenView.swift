//
//  OnboardingLandingScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI
import Essentials

struct OnboardingLandingScreenView<Content: View>: View {
    let landingScreenOptions: [EssentialsOnboardingSelectionView<Content>.Model]
    let onSelection: () -> Void

    var body: some View {
        VStack(spacing: 16.0) {
            Text("Welcome")
                .font(.largeTitle)
            Text("What's your board game experience?")
                .font(.subheadline)
            EssentialsOnboardingSelectionView(options: landingScreenOptions) { _ in
                onSelection()
            }
        }
    }
}
