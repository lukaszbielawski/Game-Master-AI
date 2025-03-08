//
//  LaunchScreenView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 04/03/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isLogoScaling: Bool = false
    @State private var isVisible: Bool = true

    var body: some View {
        ZStack {
            if isVisible {
                ZStack(alignment: .center) {
                    background
                        .ignoresSafeArea(.all)
                    logo
                        .scaleEffect(isLogoScaling ? 5 : 1)
                }
                .animation(.easeIn(duration: 0.3), value: isVisible)
            }
        }

        .task { @MainActor in
            withAnimation(.easeOut(duration: 1.0)) {
                isLogoScaling = true
            }
            try? await Task.sleep(for: .seconds(0.35))
            withAnimation(.easeIn(duration: 0.3)) {
                isVisible = false
            }
        }
    }
}

extension LaunchScreenView {
    var background: some View {
        GeometryReader { geo in
            Image("ImageGradientBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }

    var logo: some View {
        Image("VectorLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200)
            .offset(y: -7)
    }
}
