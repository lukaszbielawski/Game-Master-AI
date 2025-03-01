//
//  PaywallView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import Essentials
import StoreKit
import SwiftUI

struct PaywallView: View {
    let hasTrial: Bool
    @StateObject var vm: PaywallViewModel
    @Namespace var faqBottom

    @Environment(\.dismiss) var dismiss

    init(hasTrial: Bool) {
        self.hasTrial = hasTrial
        self._vm = StateObject(wrappedValue: .init(hasTrial: hasTrial))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 16.0) {
                            Text("Make Every Moment Count")
                                .foregroundStyle(Color.essentialsColor(named: "TintOnAccentColor"))
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding(.leading, 24.0)
                                .padding(.trailing, 48.0)
                                .overlay {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .font(.title3)
                                            .foregroundStyle(Color.essentialsColor(named: "TintOnAccentColor"))
                                            .opacity(0.3)
                                            .contentShape(Rectangle().size(width: 44, height: 44))
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.65)) { [weak vm] in
                                                    if hasTrial {
                                                        vm?.cancelPaywall()
                                                    }
                                                    dismiss()
                                                }
                                            }
                                            .padding(8.0)
                                    }
                                }
                            Text(LocalizedStringKey("**Less Rules, More Laughs!** 🎉❤️"))
                                .foregroundStyle(Color.essentialsColor(named: "TintOnAccentColor"))
                                .font(.subheadline)
                            Image("ImageBoardGameFamily")
                                .resizable()
                                .scaledToFit()
                                .overlay {
                                    Rectangle().fill(Material.ultraThinMaterial.opacity(0.8))
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 24.0))
                                .frame(maxHeight: geo.size.height * 0.3)

                            VStack(spacing: 16) {
                                EssentialsPaywallPricesView(products: vm.products, selectedProduct: $vm.selectedProduct)
                                    .padding(.top, 16.0)
                                Group {
                                    HStack {
                                        Text("🕒")
                                            .font(.title)
                                        Text(LocalizedStringKey("**Reduce** rulebook discussions by 80%"))
                                        Spacer()
                                    }
                                    HStack {
                                        Text("🔥")
                                            .font(.title)
                                        Text(LocalizedStringKey("**Perfect** for game nights – no more rule debates!"))
                                        Spacer()
                                    }
                                    HStack {
                                        Text("🚀")
                                            .font(.title)
                                        Text(LocalizedStringKey("**Instant** setup – just scan & start playing!"))
                                        Spacer()
                                    }
                                }

                                .padding(.horizontal)
                                EssentialsPaywallSocialProofView(
                                    title: "Join over 1,000 board game lovers and enjoy smoother game nights!",
                                    rating: "4.9 ★"
                                )
                                .padding(.top)

                                Text("Unlock full potetnial with Premium")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.vertical)

                                EssentialsPaywallPlanComparisonView(rowModels: vm.comparisonModels, geoProxy: geo) {
                                    EssentialsPaywallPlanComparisonHeaderView(geoProxy: geo) {
                                        VStack {
                                            Text("✨")
                                            Text("Features")
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    } basicLabel: {
                                        VStack {
                                            Text("🤔")
                                            Text("Basic")
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    } premiumLabel: {
                                        VStack {
                                            Text("👑")
                                            Text("Premium")
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    }
                                }

                                Text("Words from our users")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.vertical)
                                EssentialsPaywallReviewsView(models: vm.reviewsModels, geoProxy: geo)

                                EssentialsPaywallPricesView(products: vm.products, selectedProduct: $vm.selectedProduct)
                                    .padding(.top, 32.0)

                                Text("Frequently Asked Questions (FAQ)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.vertical)
                                    .padding(.top, 16.0)

                                EssentialsPaywallFAQsView(models: vm.faqModels, geoProxy: geo) { _ in
                                    withAnimation {
                                        scrollProxy.scrollTo(faqBottom)
                                    }
                                }
                                .padding(.bottom, 32.0)
                                .padding(.bottom, geo.size.height * 0.10)
                                .id(faqBottom)
                            }
                            .padding(.vertical)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .background {
                                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 32.0, bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 32.0)
                                )
                                .fill(Color.listElementBackgroundColor)
                                .padding(.bottom, -geo.size.height * 0.5)
                                .ignoresSafeArea(.all)
                            }
                            .compositingGroup()
                        }
                    }
                }
                .background {
                    LinearGradient(colors: [Color.accentColor, Color.purple], startPoint: .topLeading, endPoint: .bottomLeading)
                        .ignoresSafeArea(.all)
                }
                if let selectedProduct = vm.selectedProduct {
                    EssentialsPaywallFloatingButton(
                        product: selectedProduct,
                        geoProxy: geo,
                        hasTrial: selectedProduct.subscription?.introductoryOffer != nil
                    ) {
                        Task(priority: .userInitiated) {
                            await vm.buyProduct {
                                dismiss()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).animation(.easeOut(duration: 1.00)))
                }
            }
        }
        .environmentObject(vm)
    }
}
