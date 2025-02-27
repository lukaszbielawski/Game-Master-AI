//
//  ChatRefillDialogSheetView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 26/02/2025.
//

import Essentials
import SwiftUI

struct ChatRefillDialogSheetView<Content: View>: View {
    let options: [EssentialsOnboardingSelectionView.Model] = [
        .init(title: " Watch an Ad – Refill your messages for free") {
            AnyView(Image(systemName: "movieclapper"))
        },
        .init(title: "Unlimited chat access and extra features", isCallToActionStyled: true) {
            AnyView(Image(systemName: "crown.fill")
                .foregroundStyle(Color.essentialsColor(named: "PremiumColor")))
        }
    ]

    @ObservedObject var router = RouterState.shared
    @ObservedObject var adProvider = EssentialsAdProvider.shared

    let onDismiss: (Bool) -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 16.0) {
                Text("🔒 No More Free Messages")
                    .font(.title)
                    .padding(.top, 16.0)

                Text("You’ve used up your free messages. Choose an option to continue chatting.")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                EssentialsOnboardingSelectionView(options: options) { selection in
                    if selection.id == options[1].id {
                        router.currentSheetRoute = .none
                        router.push(.paywallView(hasTrial: false))
                    } else {
                        router.currentSheetRoute = .none
                        Task { @MainActor in
                            await adProvider.showRewardedAd { succeded in
                                if !succeded {
                                    let toast: EssentialsToast = .failure("Could not load ad. Please ensure you have internet connection")
                                    EssentialsToastProvider.shared.enqueueToast(toast)
                                }
                                onDismiss(succeded)
                            }
                        }
                    }
                }
                .padding(.top, 16.0)
                Spacer()
            }
        }.onReceive(adProvider.adDidDismissSubject) { adType in
            if adType == .rewardedAd {
                onDismiss(false)
            }
        }
        .task(priority: .userInitiated) {
            await adProvider.loadRewardedAd()
        }
        .padding()
        .modifier(EssentialsAutoHeightSheetModifier(fraction: .constant(0.6)))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
    }
}
