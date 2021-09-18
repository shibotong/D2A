//
//  SubscriptionView.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import SwiftUI
import Foundation
import StoreKit

struct StoreView: View {
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var storeManager: StoreManager
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    env.subscription = false
                }) {
                    Image(systemName: "xmark").foregroundColor(Color(.label))
                }
            }.padding()
            Divider()
            Button(action: {storeManager.restorePurchase()}) {
                Text("restore")
            }
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading) {
                                Text("Upgrade to D2A Plus").font(.custom(fontString, size: 20)).bold()
                                Text("and get access to all features").font(.custom(fontString, size: 20)).bold()
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                buildFeature("Unlimit Following Users")
                                buildFeature("Unlock Widgets")
                            }
                            VStack(alignment: .leading) {
                                Text("Select your subscription").bold().font(.custom(fontString, size: 20))
//                                VStack {
//                                    ForEach(storeManager.products, id: \.self) { product in
//                                        ProductSubView(product: product)
//                                            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.primaryDota, lineWidth: storeManager.selectedProduct == product ? 1 : 0))
//                                            .onTapGesture {
//                                                self.storeManager.selectedProduct = product
//                                            }
//                                    }
//                                }
                                if storeManager.monthlySubscription != nil {
                                    ProductSubView(product: storeManager.monthlySubscription!.product)
                                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.primaryDota, lineWidth: storeManager.selectedProduct == storeManager.monthlySubscription ? 1 : 0))
                                        .onTapGesture {
                                            self.storeManager.selectedProduct = storeManager.monthlySubscription
                                        }
                                }
                                if storeManager.quarterlySubscription != nil {
                                    ProductSubView(product: storeManager.quarterlySubscription!.product)
                                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.primaryDota, lineWidth: storeManager.selectedProduct == storeManager.quarterlySubscription ? 1 : 0))
                                        .onTapGesture {
                                            self.storeManager.selectedProduct = storeManager.quarterlySubscription
                                        }
                                }
                                if storeManager.annuallySubscription != nil {
                                    ProductSubView(product: storeManager.annuallySubscription!.product)
                                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.primaryDota, lineWidth: storeManager.selectedProduct == storeManager.annuallySubscription ? 1 : 0))
                                        .onTapGesture {
                                            self.storeManager.selectedProduct = storeManager.annuallySubscription
                                        }
                                }
                            }
                            Spacer()
                        }.padding()
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        storeManager.purchase()
                    }) {
                        buildSubscribeButton()
                }.padding(.horizontal)
                }
            }
        }
    }
    
    @ViewBuilder private func buildFeature(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill").foregroundColor(Color(.systemGreen))
            Text(text).font(.custom(fontString, size: 15))
        }
    }
    
    @ViewBuilder private func buildSubscribeButton() -> some View {
        ZStack {
            Capsule().foregroundColor(.primaryDota.opacity(0.8))
            Text("\(env.subscriptionStatus ? "Subscribed" : "Subscribe Now")").font(.custom(fontString, size: 17)).bold().foregroundColor(.white)
            HStack {
                Spacer()
                Circle().frame(width: 60, height: 50).foregroundColor(env.subscriptionStatus ? .secondaryDota : .primaryDota).overlay(Image(systemName: "checkmark").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white))
            }
        }.frame(height: 60)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(StoreManager.shared)
    }
}



struct ProductSubView: View {
    var product: SKProduct
    @Environment(\.colorScheme) var color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30).foregroundColor(color == .light ? Color(.systemBackground) : Color(.secondarySystemBackground)).shadow(color: Color(.systemGray5), radius: color == .light ? 10 : 0)
            HStack {
                badge()
                VStack(alignment: .leading) {
                    Text("\(product.subscriptionPeriod!.numberOfUnits) \(getUnit())\(product.subscriptionPeriod!.numberOfUnits > 1 ? "s" : "")").bold().font(.custom(fontString, size: 20))
                    Text("\(product.monthlyCost ?? "") per month").font(.custom(fontString, size: 12)).foregroundColor(Color(.systemGray))
                }
                Spacer()
                Text("\(product.localizedPrice ?? "Free")").bold().foregroundColor(.primaryDota)
            }.padding()
        }.frame(height: 100)
    }
    
    @ViewBuilder private func badge() -> some View {
        ZStack {
            Circle().frame(width: 60, height: 60).foregroundColor(self.getColor())
            Image("battle_icon").renderingMode(.template).resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.white.opacity(0.5))
        }
    }
    
    private func getColor() -> Color {
        if product.subscriptionPeriod!.unit == .year {
            return .primaryDota
        } else {
            if product.subscriptionPeriod!.numberOfUnits > 1 {
                return Color(.systemBlue)
            } else {
                return Color(.systemGreen)
            }
        }
    }
    
    private func getUnit() -> String {
        switch product.subscriptionPeriod!.unit {
        case .day:
            return "day"
        case .month:
            return "month"
        case .week:
            return "week"
        case .year:
            return "year"
        @unknown default:
            return ""
        }
    }
}
