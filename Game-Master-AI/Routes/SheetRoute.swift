//
//  SheetRoute.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import SwiftUI

enum SheetRoute: EssentialsSheetRouteProtocol {
    case privacyPolicy(vm: EssentialsSettingsViewModel)
    case termsAndConditions(vm: EssentialsSettingsViewModel)
    case addBoardGameView
    case addBoardGameLoadingView(vm: ChatAddNewGameViewModel)
    case mail
    case pdfFilePickerView(_ vm: ChatAddNewGameViewModel)

    var body: some View {
        switch self {
        case .privacyPolicy(let vm):
            EssentialsSettingsSheetView(
                title: "Privacy policy",
                sheetType: .privacyPolicy
            )
            .environmentObject(vm)
        case .termsAndConditions(let vm):
            EssentialsSettingsSheetView(
                title: "Terms and conditions",
                sheetType: .termsAndConditions
            )
            .environmentObject(vm)
        case .addBoardGameView:
            ChatAddNewGameView()
        case .addBoardGameLoadingView(let vm):
            ChatAddNewGameView.LoadingView {}
                .environmentObject(vm)
                .interactiveDismissDisabled()
        case .mail:
            EssentialsMailView()
        case .pdfFilePickerView(let vm):
            ChatAddNewGameView.PDFFilePickerView()
                .environmentObject(vm)
        }
    }

    var id: Int { rawValue }

    var rawValue: Int {
        return switch self {
        case .privacyPolicy:
            1
        case .termsAndConditions:
            2
        case .addBoardGameView:
            3
        case .addBoardGameLoadingView:
            4
        case .mail:
            5
        case .pdfFilePickerView:
            6
        }
    }
}

extension SheetRoute: EssentialsSettingsViewSheetRouteDelegate {
    static func getPrivacyPolicySheetRoute(vm: EssentialsSettingsViewModel) -> SheetRoute {
        .privacyPolicy(vm: vm)
    }

    static func getTermsAndConditionsSheetRoute(vm: EssentialsSettingsViewModel) -> SheetRoute {
        .termsAndConditions(vm: vm)
    }

    static func getMailSheetRoute() -> SheetRoute {
        .mail
    }
}
