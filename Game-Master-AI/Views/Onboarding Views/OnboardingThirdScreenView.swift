//
//  OnboardingThirdScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import SwiftUI

struct OnboardingThirdScreenView: View {
    @State private var isScreenShown: Bool = false
    @State private var isImageShown: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                Spacer()
                Text("AI-powered rule assistant")
                    .font(.largeTitle)
                    .opacity(isScreenShown ? 1.0 : 0.0)
                Spacer()
            }

            Text("Ask about game rules and get instant answers — based only on the rulebook you provide. No more flipping through long manuals!")
                .font(.subheadline)
                .opacity(isScreenShown ? 1.0 : 0.0)
                .multilineTextAlignment(.leading)

            Group {
                HStack {
                    Text("🚫")
                        .font(.largeTitle)
                    Text(LocalizedStringKey("**No more** hallucinations – The AI strictly follows the rules from your scanned manual."))
                    Spacer()
                }
                HStack {
                    Text("🎯")
                        .font(.largeTitle)
                    Text(LocalizedStringKey("**Accurate** answers – Get precise responses based on the game's official instructions."))
                    Spacer()
                }
            }
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            if isImageShown {
                HStack(spacing: 0.0) {
                    Spacer()
                    Image("ImageBoardGameScan")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(32.0)
                        .frame(width: 200)
                        .rotationEffect(.degrees(30.0))
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).animation(.easeOut(duration: 0.65)),
                            removal: .move(edge: .leading).animation(.easeOut(duration: 0.65))))
                    Spacer()
                }
            }
        }
        .opacity(isScreenShown ? 1.0 : 0.0)
        .padding(.horizontal)
        .task {
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeInOut(duration: 1.0)) {
                isScreenShown = true
            }
            withAnimation(.spring(duration: 0.65, bounce: 0.5)) {
                isImageShown = true
            }
        }
    }
}
