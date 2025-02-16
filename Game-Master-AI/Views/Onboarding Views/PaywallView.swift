//
//  PaywallView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 13/02/2025.
//

import Essentials
import SwiftUI

struct PaywallView: View {
    let hasTrial: Bool
    @StateObject var vm: PaywallViewModel

    init(hasTrial: Bool) {
        self.hasTrial = hasTrial
        self._vm = StateObject(wrappedValue: .init(hasTrial: hasTrial))
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 16.0) {
                    Text("Make Every Moment Count")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text(LocalizedStringKey("**Less Rules, More Laughs!** 🎉❤️"))
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
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 16.0)
                            EssentialsLoadingStateView(vm.products) { products in
                                HStack(spacing: 16.0) {
                                    ForEach(products) { product in
                                        let isYearly = product.subscription?.subscriptionPeriod.unit == .year
                                        EssentialsPaywallPriceView(duration: isYearly ? 12 : 1,
                                                                   durationUnit: isYearly ? "Months" : "Month",
                                                                   fullPrice: product.price,
                                                                   currencyCode: product.priceFormatStyle.currencyCode,
                                                                   subTitle: isYearly ? "billed annually" : "billed monthly",

                                                                   toastText: isYearly ? "Save 20%" : "Popular",
                                                                   subtoastText: product.subscription?.introductoryOffer != nil ? "**Free** 3-day trial" : nil,
                                                                   isSelected: vm.selectedProduct == product)
                                        {
                                            vm.selectedProduct = product
                                        }
                                    }
                                }
                            }
                            Spacer(minLength: 16.0)
                        }
                        .foregroundStyle(Color.tintColor)
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

                        EssentialsPaywallPlanComparisonView(geoProxy: geo)
                            .padding(.top)
                    }
                    .padding(.vertical)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .background {
                        RoundedRectangle(cornerRadius: 32.0)
                            .fill(Color.listElementBackgroundColor)
                            .ignoresSafeArea(.all)
                    }
                    .compositingGroup()
                }
            }
            .background {
                LinearGradient(colors: [Color.accentColor, Color.purple], startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea(.all)
            }
        }
        .environmentObject(vm)
    }
}
