//
//  SheetRoute.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 03/02/2025.
//

import Essentials
import SwiftUI

enum SheetRoute: EssentialsSheetRouteProtocol {
    case privacyPolicy(contentFileName: String)
    case termsAndConditions(contentFileName: String)
    case addBoardGameView(_ vm: ChatAddNewGameViewModel? = nil)
    case addBoardGameLoadingView(vm: ChatAddNewGameViewModel)
    case mail
    case pdfFilePickerView(_ vm: ChatAddNewGameViewModel)
    case addCounterView(_ vm: CountersViewModel)
    case refillDialogSheet(onDismiss: (Bool) -> Void)

    var body: some View {
        switch self {
        case .privacyPolicy(let contentFileName):
            EssentialsTextContentSheetView(
                title: "Privacy policy",
                contentFileName: contentFileName
            )
        case .termsAndConditions(let contentFileName):
            EssentialsTextContentSheetView(
                title: "Terms and conditions",
                contentFileName: contentFileName
            )
        case .addBoardGameView(let vm):
            ChatAddNewGameView(vm: vm)
        case .addBoardGameLoadingView(let vm):
            ChatAddNewGameView.LoadingView {}
                .environmentObject(vm)
                .interactiveDismissDisabled()
        case .mail:
            EssentialsMailView()
        case .pdfFilePickerView(let vm):
            ChatAddNewGameView.PDFFilePickerView()
                .environmentObject(vm)
        case .addCounterView(let vm):
            CountersView.AddNewCounterView()
                .environmentObject(vm)
        case .refillDialogSheet(let onDismiss):
            ChatRefillDialogSheetView<AnyView>(onDismiss: onDismiss)
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
        case .addCounterView:
            7
        case .refillDialogSheet:
            8
        }
    }
}

extension SheetRoute: EssentialsSettingsViewSheetRouteDelegate {
    static func getPrivacyPolicySheetRoute(contentFileName: String) -> SheetRoute {
        .privacyPolicy(contentFileName: contentFileName)
    }

    static func getTermsAndConditionsSheetRoute(contentFileName: String) -> SheetRoute {
        .termsAndConditions(contentFileName: contentFileName)
    }

    static func getMailSheetRoute() -> SheetRoute {
        .mail
    }
}
