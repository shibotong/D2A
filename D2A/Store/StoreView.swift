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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                closeButton
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
        .alert(isPresented: $storeManager.errorIsPresented, error: storeManager.error, actions: {
            Button("OK") {

            }
        })
    }
    
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill").foregroundColor(.primaryDota)
        })
    }
    
    private var purchaseButton: some View {
        Button(action: {
            Task {
                await storeManager.purchase()
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15).foregroundColor(storeManager.isPurchased ? .secondaryDota : .primaryDota)
                if storeManager.isPurchasing {
                    ProgressView().progressViewStyle(.circular)
                } else {
                    Text(buildSubscribeString()).font(.system(size: 17)).bold().foregroundColor(.white)
                }
            }.frame(height: 60)
        })
    }
    
    @ViewBuilder private func buildQuestion(question: LocalizedStringKey, answer: LocalizedStringKey) -> some View {
        VStack(alignment: .leading) {
            Text(question).font(.system(size: 18)).bold().foregroundColor(Color(.secondaryLabel))
            Text(answer).font(.system(size: 12)).fixedSize(horizontal: false, vertical: true).foregroundColor(Color(.tertiaryLabel))
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
            purchaseButton
                .disabled(storeManager.isPurchased || storeManager.isPurchasing || storeManager.product == nil)
            VStack {
                Button(action: {
                    storeManager.restorePurchase()
                }, label: {
                    Text("Restore Purchase").font(.system(size: 15)).bold()
                })
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
        if storeManager.isPurchased {
            return "Unlocked"
        }
        if storeManager.isLoadingProduct {
            return "Loading..."
        }
        if let selectedProduct = storeManager.product {
            return "SubscriptionButtonDescription \(selectedProduct.displayPrice)"
        } else {
            return "Failed to load product"
        }
    }
}

#if DEBUG
#Preview("Success") {
    StoreView()
        .environmentObject(StoreManager.success)
}

#Preview("User Cancelled") {
    StoreView()
        .environmentObject(StoreManager.userCancelled)
}

#Preview("Pending") {
    StoreView()
        .environmentObject(StoreManager.pending)
}

#Preview("Loading Product") {
    StoreView()
        .environmentObject(StoreManager(isLoadingProduct: true))
}

#Preview("Loading Product Failed") {
    StoreView()
        .environmentObject(StoreManager())
}
#endif
