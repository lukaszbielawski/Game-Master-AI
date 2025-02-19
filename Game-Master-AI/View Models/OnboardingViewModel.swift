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
    @Published var currentScreenContinueButtonState: EssentialsOnboardingContinueButton.State = .hidden
    @Published var willBeUsingBackTransition: Bool = false
    @Published var isBackButtonDisabled: Bool = false

    @Published var screenTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
        .animation(.easeInOut(duration: 0.35))

    var visitedScreens: Set<OnboaringScreenRoute> = []

    let launchDetector = EssentialsLaunchDetector.shared
    let analyticsProvider = EssentialsFirebaseAnalyticsProvider.shared

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

    let landingScreenOptions: [EssentialsOnboardingSelectionView.Model] = [
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
            }.onAppear { [weak self] in
                guard let self else { return }
                if !visitedScreens.contains(route) {
                    analyticsProvider.logScreenView(screenName: route.screenName)
                    visitedScreens.insert(route)
                }
                currentScreenContinueButtonState = .hidden
            }
        case .firstOnboardingScreen:
            OnboardingFirstScreenView()
                .onAppear { [weak self] in
                    guard let self else { return }
                    currentScreenContinueButtonState = .visible
                }
        case .secondOnboardingScreen:
            OnboardingSecondScreenView()
                .onAppear { [weak self] in
                    guard let self else { return }
                    currentScreenContinueButtonState = .visible
                }
        case .thirdOnboardingScreen:
            OnboardingThirdScreenView()
                .onAppear { [weak self] in
                    guard let self else { return }
                    currentScreenContinueButtonState = .visible
                }
        case .forthOnboardingScreen:
            OnboardingForthScreenView()
                .onAppear { [weak self] in
                    guard let self else { return }
                    currentScreenContinueButtonState = .visible
                }
        case .chatSampleScreen:
            OnboardingChatSampleScreenView()
                .onAppear { [weak self] in
                    guard let self else { return }
                    currentScreenContinueButtonState = .skip
                }
        case .paywall:
            PaywallView(hasTrial: true)
                .onAppear { [weak self] in
                    guard let self else { return }
                    launchDetector.markOnboardingAsSeenAtNextLaunch()
                    currentScreenContinueButtonState = .hidden
                }
        }
    }

    func present(_ screen: OnboaringScreenRoute) {
        if !visitedScreens.contains(screen) {
            analyticsProvider.logScreenView(screenName: screen.screenName)
            visitedScreens.insert(screen)
        }
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
    case paywall

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
        case .chatSampleScreen:
            .paywall
        case .paywall:
            .none
        }
    }

    public var screenName: String {
        switch self {
        case .landingScreen:
            "LandingScreen"
        case .firstOnboardingScreen:
            "FirstOnboardingScreen"
        case .secondOnboardingScreen:
            "SecondOnboardingScreen"
        case .thirdOnboardingScreen:
            "ThirdOnboardingScreen"
        case .forthOnboardingScreen:
            "ForthOnboardingScreen"
        case .chatSampleScreen:
            "ChatSampleScreen"
        case .paywall:
            "Paywall"
        }
    }
}
