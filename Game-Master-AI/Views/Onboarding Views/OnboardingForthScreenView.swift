//
//  OnboardingForthScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI

struct OnboardingForthScreenView: View {
    @State private var isScreenShown: Bool = false
    @State private var isDiceShown: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                DicesView(isOnboardingInitialized: true)
                    .scaleEffect(2.0)
                    .offset(y: geo.size.height * 0.125)
                VStack(alignment: .leading, spacing: 16.0) {
                    HStack {
                        Spacer()
                        Text("Game Accessories")
                            .font(.largeTitle)
                            .opacity(isScreenShown ? 1.0 : 0.0)
                        Spacer()
                    }

                    Text("Need dice, counter, or a timer? We’ve got you covered! 🎲")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .opacity(isScreenShown ? 1.0 : 0.0)
                }
            }
        }
        .padding(.horizontal, 32)
        .task {
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.easeInOut(duration: 0.65)) {
                isDiceShown = true
            }
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.easeInOut(duration: 1.0)) {
                isScreenShown = true
            }
        }
    }
}
