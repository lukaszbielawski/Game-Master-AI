//
//  OnboardingViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import Essentials
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var navigationStack: [OnboaringScreenRoute] = [.landingScreen]
    @Published var screenTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
        .animation(.easeInOut(duration: 0.35))

    @Published var willBeUsingBackTransition: Bool = false

    var transition: AnyTransition {
        if willBeUsingBackTransition {
            .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing))
                .animation(.easeInOut(duration: 0.35))
        } else {
            .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading))
                .animation(.easeInOut(duration: 0.35))
        }
    }

    var currentScreenHasContinueButton: Bool {
        guard let currentScreen = navigationStack.last else { return false }
        return switch currentScreen {
        case .landingScreen:
            false
        case .firstOnboardingScreen:
            true
        case .secondOnboardingScreen:
            true
        case .thirdOnboardingScreen:
            true
        case .forthOnboardingScreen:
            true
        case .chatSampleScreen:
            false
        }
    }

    @Published var landingScreenOptions: [EssentialsOnboardingSelectionView.Model] = [
        .init(title: "I'm a beginner") {
            Text("🎲")
        },
        .init(title: "I play ocassionally") {
            Text("🃏")
        },
        .init(title: "I'm a board game pro!") {
            Text("♟️")
        },
    ]

    var screenCompletionFraction: CGFloat {
        CGFloat(navigationStack.count) / CGFloat(OnboaringScreenRoute.allCases.count)
    }

    @ViewBuilder
    func currentScreenBody(_ route: OnboaringScreenRoute) -> some View {
        switch route {
        case .landingScreen:
            OnboardingLandingScreenView(landingScreenOptions: landingScreenOptions) { [weak self] in
                self?.present(.firstOnboardingScreen)
                EssentialsHapticService.shared.play(.soft)
            }
        case .firstOnboardingScreen:
            OnboardingFirstScreenView { [weak self] in
                self?.present(.secondOnboardingScreen)
            }
        case .secondOnboardingScreen:
            OnboardingSecondScreenView { [weak self] in
                self?.present(.thirdOnboardingScreen)
            }
        case .thirdOnboardingScreen:
            OnboardingThirdScreenView { [weak self] in
                self?.present(.forthOnboardingScreen)
            }
        case .forthOnboardingScreen:
            OnboardingForthScreenView { [weak self] in
                self?.present(.chatSampleScreen)
            }
        default:
            EmptyView()
        }
    }

    func present(_ screen: OnboaringScreenRoute) {
        willBeUsingBackTransition = false
        withAnimation(.easeInOut(duration: 0.35)) {
            navigationStack.append(screen)
        }
    }

    func dismiss() {
        if navigationStack.count > 1 {
            willBeUsingBackTransition = true
            withAnimation(.easeInOut(duration: 0.35)) {
                navigationStack.removeLast()
            }
        }
    }
}

public enum OnboaringScreenRoute: EssentialsOnboardingScreenRouteProtocol {
    case landingScreen
    case firstOnboardingScreen
    case secondOnboardingScreen
    case thirdOnboardingScreen
    case forthOnboardingScreen
    case chatSampleScreen

    public var nextScreen: OnboaringScreenRoute? {
        switch self {
        case .landingScreen:
            .firstOnboardingScreen
        case .firstOnboardingScreen:
            .secondOnboardingScreen
        case .secondOnboardingScreen:
            .thirdOnboardingScreen
        case .thirdOnboardingScreen:
            .forthOnboardingScreen
        case .forthOnboardingScreen:
            .chatSampleScreen
        default:
            .none
        }
    }
}
