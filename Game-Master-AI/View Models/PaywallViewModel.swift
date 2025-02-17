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
    @Published var products: EssentialsLoadingState<[Product], Error> = .initial
    @Published var selectedProduct: Product? = nil
    @Published var screenTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    .animation(.easeInOut(duration: 0.35))

    let hasTrial: Bool
    let storeKitService = EssentialsStoreKitService()

    let comparisonModels: [EssentialsPaywallPlanComparisonModel] = [
        .init(subject: "📖 Process game manuals", basicValue: "1", premiumValue: "30 monthly"),
        .init(subject: "💬 AI rule questions", basicValue: "3, then ad", premiumValue: "200 daily"),
        .init(subject: "🚫 Ads-free experience", basicValue: "❌", premiumValue: "✅"),
        .init(subject: "🎙️ Voice input for chat", basicValue: "❌", premiumValue: "✅"),
    ]

    let reviewsModels: [EssentialsPaywallReviewsModel] = [
        .init(personName: "Anna777", description: "I used to always watch video tutorials instead of reading rulebooks, but that doesn’t work when you're playing live. This app makes learning new games effortless – I can just ask and play!"),
        .init(personName: "Oli_S", description: "Flipping through pages just to find one rule in the middle of a game was the worst. Now I just ask, and I get the answer instantly. The game flows so much better!"),
        .init(personName: "Jakub85", description: "My kids hate waiting for me to explain rules. Now, I just ask the assistant, and we can start playing right away. It makes board games way more fun!"),
    ]

    let faqModels: [EssentialsPaywallFAQModel] = [
        .init(
            question: "What is the difference between the Basic and Premium plans?",
            answer: "The **Basic** plan gives you limited access to game rules, ads, and basic features. The **Premium** plan unlocks full access to all game rules, removes ads, and provides advanced features like voice input and unlimited questions to the AI assistant."
        ),
        .init(
            question: "Can I try Premium features before committing?",
            answer: "Yes! You can enjoy a **3-day free trial** of the Premium plan, allowing you to experience all the features before deciding to upgrade."
        ),
        .init(
            question: "Are the game rules provided accurate?",
            answer: "Absolutely! Our AI-powered assistant provides precise answers based on the official rulebooks you scan. No more confusion or misunderstandings during gameplay!"
        ),
        .init(
            question: "Is my payment information secure?",
            answer: "Yes, your payment information is processed securely through the App Store, and we never store your payment details. All transactions are encrypted for your safety."
        ),
    ]

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
}
