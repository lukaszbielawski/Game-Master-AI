//
//  PaywallViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 16/02/2025.
//

import Essentials
import StoreKit
import SwiftUI

@MainActor
final class PaywallViewModel: ObservableObject {
    let hasTrial: Bool

    let storeKitService = EssentialsStoreKitService()
    @Published var products: EssentialsLoadingState<[Product], Error> = .initial
    @Published var selectedProduct: Product? = nil

    init(hasTrial: Bool) {
        self.hasTrial = hasTrial
        Task(priority: .userInitiated) {
            await fetchProducts(hasTrial: hasTrial)
        }
    }

    private func fetchProducts(hasTrial: Bool) async {
        products = .loading
        let result = await storeKitService.fetchProducts(hasTrial: hasTrial)
        switch result {
        case .success(let success):
            let fetchedProducts = success.sorted(by: { $0.price > $1.price })
            products = .success(fetchedProducts)
            selectedProduct = fetchedProducts.first
        case .failure(let failure):
            products = .failure(error: failure)
        }
    }

    @Published var screenTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
        .animation(.easeInOut(duration: 0.35))
}
