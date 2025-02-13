//
//  OnboardingFirstScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI

struct OnboardingFirstScreenView: View {
    @State private var isTitleShown: Bool = false
    @State private var isSubtitleShown: Bool = false

    let onSelection: () -> Void

    var body: some View {
        VStack(spacing: 16.0) {
            Text("That's perfect!")
                .font(.largeTitle)
                .opacity(isTitleShown ? 1.0 : 0.0)
            Text("No matter your experience, we’ve got you covered!")
                .font(.subheadline)
                .opacity(isSubtitleShown ? 1.0 : 0.0)

            Image("ImageBoardGame")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: Color(.accent).opacity(0.5), radius: 10, x: 0.0, y: 10.0)
                .opacity(isSubtitleShown ? 1.0 : 0.0)
                .padding(32.0)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeInOut(duration: 1.0)) {
                isTitleShown = true
            }
            try? await Task.sleep(for: .milliseconds(1000))
            withAnimation(.easeInOut(duration: 1.0)) {
                isSubtitleShown = true
            }
        }
    }
}
