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
                buildCloseButton()
                Spacer()
            }
            .padding()
            Divider()
            VStack(alignment: .leading, spacing: 25) {
                Text("Upgrade to D2A Pro")
                    .font(.system(size: 30))
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                Text("Purchase D2A Pro to unlock all features and support us to build a better app.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(.secondaryLabel))
                    .fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 10) {
                    buildFeature("Unlimit Following Users")
                    buildFeature("Unlock Widgets")
                }
                Spacer()
                buildSubscribeButton()
            }.padding()
        }
    }
    
    @ViewBuilder private func buildQuestion(question: LocalizedStringKey, answer: LocalizedStringKey) -> some View {
        VStack(alignment: .leading) {
            Text(question).font(.system(size: 18)).bold().foregroundColor(Color(.secondaryLabel))
            Text(answer).font(.system(size: 12)).fixedSize(horizontal: false, vertical: true).foregroundColor(Color(.tertiaryLabel))
        }
    }
    
    @ViewBuilder private func buildCloseButton() -> some View {
        Button(action: {
            env.subscriptionSheet = false
        }) {
            Image(systemName: "xmark.circle.fill").foregroundColor(.primaryDota)
        }
    }
    
    @ViewBuilder private func buildFeature(_ text: LocalizedStringKey) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill").foregroundColor(Color(.systemGreen))
            Text(text).font(.system(size: 15))
        }
    }
    
    @ViewBuilder private func buildSubscribeButton() -> some View {
        VStack(spacing: 15) {
            Button(action: {
                Task {
                 try await storeManager.purchase()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(env.subscriptionStatus ? .secondaryDota : .primaryDota)
                    Text(buildSubscribeString()).font(.system(size: 17)).bold().foregroundColor(.white)
                }.frame(height: 60)
            }
            .disabled(env.subscriptionStatus)
            VStack {
                Button(action: {
                    storeManager.restorePurchase()
                }) {
                    Text("Restore Purchase").font(.system(size: 15)).bold()
                }
                HStack {
                    Link(destination: URL(string: PRIVACY_POLICY)!, label: {
                        Text("Terms of Use").font(.system(size: 15)).bold()
                    })
                    Text("and").font(.system(size: 15))
                    Link(destination: URL(string: TERMS_OF_USE)!, label: {
                        Text("Privacy Policy").font(.system(size: 15)).bold()
                    })
                }
            }
        }
    }
    
    private func buildSubscribeString() -> LocalizedStringKey {
        if env.subscriptionStatus {
            return "Unlocked"
        } else {
            if let selectedProduct = storeManager.products.first {
                return "SubscriptionButtonDescription \(selectedProduct.displayPrice)"
            } else {
                return "Loading..."
            }
        }
    }
}


//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreView()
//            .environmentObject(DotaEnvironment.shared)
//            .environmentObject(StoreManager.shared)
//    }
//}




