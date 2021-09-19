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
                buildCloseButton()
            }
            .padding()
            Divider()
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 25) {
                    Text("Upgrade to D2A Plus to unlock all features")
                        .font(.custom(fontString, size: 30))
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Subscribe D2A Plus to unlock all features and support us to build a better app.")
                    .font(.custom(fontString, size: 15))
                    .foregroundColor(Color(.systemGray))
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(alignment: .leading, spacing: 10) {
                        buildFeature("Unlimit Following Users")
                        buildFeature("Unlock Widgets")
                    }
                    VStack(alignment: .leading) {
                        Text("Select your subscription").bold().font(.custom(fontString, size: 20))
                        HStack(spacing: 20) {
                            if storeManager.monthlySubscription != nil {
                                ProductSubView(product: storeManager.monthlySubscription!.product, monthlyProduct: storeManager.monthlySubscription!.product, selectedProduct: $storeManager.selectedProduct)
                            }
                            if storeManager.quarterlySubscription != nil {
                                ProductSubView(product: storeManager.quarterlySubscription!.product, monthlyProduct: storeManager.monthlySubscription!.product, selectedProduct: $storeManager.selectedProduct)
                            }
                            if storeManager.annuallySubscription != nil {
                                ProductSubView(product: storeManager.annuallySubscription!.product, monthlyProduct: storeManager.monthlySubscription!.product, selectedProduct: $storeManager.selectedProduct)
                            }
                        }
                    }
                    buildSubscribeButton()
                    
                    buildQuestion(question: "When will I be billed?", answer: "Your iTunes Account will be billed on confirmation of your subscription.")
                    buildQuestion(question: "Does My subscription Auto Renew?", answer: "Yes. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period.")
                    buildQuestion(question: "How to cancel my subscription?", answer: "You can cancel anytime with your iTunes account settings.")
                    
                }.padding()
            }
        }
    }
    
    @ViewBuilder private func buildQuestion(question: String, answer: String) -> some View {
        VStack(alignment: .leading) {
            Text(question).font(.custom(fontString, size: 18)).bold().foregroundColor(Color(.secondaryLabel))
            Text(answer).font(.custom(fontString, size: 12)).fixedSize(horizontal: false, vertical: true).foregroundColor(Color(.tertiaryLabel))
        }
    }
    
    @ViewBuilder private func buildCloseButton() -> some View {
        Button(action: {
            env.subscriptionSheet = false
        }) {
            Image(systemName: "xmark").foregroundColor(Color(.label))
        }
    }
    
    @ViewBuilder private func buildFeature(_ text: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill").foregroundColor(Color(.systemGreen))
            Text(text).font(.custom(fontString, size: 15))
        }
    }
    
    @ViewBuilder private func buildSubscribeButton() -> some View {
        VStack(spacing: 15) {
            Button(action: {
                storeManager.purchase()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(env.subscriptionStatus ? .secondaryDota : .primaryDota)
                    Text("\(buildSubscribeString())").font(.custom(fontString, size: 17)).bold().foregroundColor(.white)
                }.frame(height: 60)
            }
            .disabled(env.subscriptionStatus)
            VStack {
                Button(action: {
                    storeManager.restorePurchase()
                }) {
                    Text("Restore Purchase").font(.custom(fontString, size: 15)).bold()
                }
                HStack {
                    Link(destination: URL(string: "https://github.com/shibotong/Dota2Armory/blob/main/documents/terms-of-use.md")!, label: {
                        Text("Terms of Use").font(.custom(fontString, size: 15)).bold()
                    })
                    Text("and").font(.custom(fontString, size: 15))
                    Link(destination: URL(string: "https://github.com/shibotong/Dota2Armory/blob/main/documents/privacy-policy.md")!, label: {
                        Text("Privacy Policy").font(.custom(fontString, size: 15)).bold()
                    })
                }
            }
        }
    }
    
    private func buildSubscribeString() -> String {
        if env.subscriptionStatus {
            return "Subscribed"
        } else {
            if let selectedProduct = storeManager.selectedProduct {
                return "Get \(selectedProduct.getNumberOfUnit()) Month\(selectedProduct.getNumberOfUnit() > 1 ? "s" : "") / \(selectedProduct.localizedPrice ?? "")"
            } else {
                return "Loading..."
            }
        }
    }
}


struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(StoreManager.shared)
    }
}




