//
//  OnboardingView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import Essentials
import SwiftUI

struct OnboardingView: View {
    @StateObject var vm: OnboardingViewModel = .init()
    @State var onboardingFrame: CGSize? = nil
    @State private var isContinueButtonShown: Bool = false
    @State private var isOnboardingContinueButtonDisabled = false

    var body: some View {
        VStack {
            if let last = vm.navigationStack.last {
                vm.currentScreenBody(last)
                    .transition(vm.transition)
            }
            Spacer()
            if vm.currentScreenHasContinueButton {
                EssentialsOnboardingContinueButton {
                    if let nextScreen = vm.navigationStack.last?.nextScreen {
                        vm.present(nextScreen)
                        isOnboardingContinueButtonDisabled = true
                    }
                }
                .padding(.bottom, 32.0)
                .disabled(isOnboardingContinueButtonDisabled)
                .opacity(isContinueButtonShown ? 1.0 : 0.0)
                .task {
                    try? await Task.sleep(for: .milliseconds(2500))
                    withAnimation(.easeInOut(duration: 0.65)) {
                        isContinueButtonShown = true
                    }
                }.onAppear {
                    isOnboardingContinueButtonDisabled = false
                }
                .onDisappear {
                    withAnimation(.easeInOut(duration: 0.65)) {
                        isContinueButtonShown = false
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if vm.navigationStack.count > 1 {
                    Button {
                        vm.dismiss()
                    } label: {
                        Label("Back", systemImage: "arrow.uturn.backward")
                    }
                    .buttonStyle(.borderless)
                }
            }
            ToolbarItem(placement: .principal) {
                if let onboardingFrame {
                    ProgressView(value: vm.screenCompletionFraction, total: 1.0)
                        .frame(width: onboardingFrame.width * 0.5)
                }
            }
        }
        .onChange(of: isOnboardingContinueButtonDisabled) { newValue in
            guard newValue else { return }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.0))
                withAnimation {
                    isOnboardingContinueButtonDisabled = false
                }
            }
        }
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .frameAccessor { onboardingFrame = $0 }
    }
}
