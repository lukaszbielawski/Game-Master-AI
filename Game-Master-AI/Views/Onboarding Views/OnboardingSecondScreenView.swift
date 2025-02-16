//
//  OnboardingSecondScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI

struct OnboardingSecondScreenView: View {
    @State private var isScreenShown: Bool = false
    @State private var hourglassRotation: Angle = .radians(.pi)

    var body: some View {
        VStack(spacing: 16.0) {
            Text("Get Started Faster")
                .font(.largeTitle)
            Text("Hate reading rules? **We’ve got a fix!**")
                .font(.headline)

            Text(LocalizedStringKey("Our AI assistant will guide you on how to start playing **without reading the entire rulebook!**"))
                .font(.subheadline)
                .multilineTextAlignment(.center)

            VStack {
                Spacer()
                Image("VectorHourglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(32.0)
                Spacer()
            }
            .rotationEffect(hourglassRotation)
        }
        .opacity(isScreenShown ? 1.0 : 0.0)
        .padding(.horizontal)
        .task {
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeInOut(duration: 1.0)) {
                isScreenShown = true
                hourglassRotation = .zero
            }
        }.onDisappear {
            hourglassRotation = .radians(.pi)
        }
    }
}
