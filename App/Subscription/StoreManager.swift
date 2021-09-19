//
//  ProductsStore.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import Foundation
import StoreKit
import Purchases

class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var products: [SKProduct] = []
    
    @Published var monthlySubscription: Purchases.Package? = nil
    @Published var quarterlySubscription: Purchases.Package? = nil
    @Published var annuallySubscription: Purchases.Package? = nil
    
    @Published var selectedProduct: Purchases.Package? = nil
    
    @Published var transactionState: SKPaymentTransactionState? = nil
    
    override init() {
        super.init()
        Purchases.configure(withAPIKey: purchasesAPIKey)
        Purchases.shared.offerings { offering, error in
            self.monthlySubscription = offering?.current?.monthly
            self.quarterlySubscription = offering?.current?.threeMonth
            self.annuallySubscription = offering?.current?.annual
        }
        self.getPurchaserInfo()
    }

    func getPurchaserInfo() {
        Purchases.shared.purchaserInfo { purchaserInfo, error in
            if let info = purchaserInfo {
                self.parsePurchaseInfo(info: info)
            }
        }
    }
    
    func restorePurchase() {
        Purchases.shared.restoreTransactions { purchaserInfo, error in
            if let info = purchaserInfo {
                self.parsePurchaseInfo(info: info)
            }
        }
    }
    
    func parsePurchaseInfo(info: Purchases.PurchaserInfo) {
        if let active = info.entitlements["D2APlus"]?.isActive {
            print("subscription status \(active)")
            let formatter = DateFormatter()
            formatter.dateFormat = "yy-MM-dd hh:mm:ss"
            print("expire time \(String(describing: formatter.string(for: info.entitlements["D2APlus"]?.expirationDate)))")
            DotaEnvironment.shared.subscriptionStatus = active
        } else {
            DotaEnvironment.shared.subscriptionStatus = false
        }
    }
    
    func purchase() {
        if let product = self.selectedProduct {
            Purchases.shared.purchasePackage(product) { transaction, purchaserInfo, error, userCancelled in
                if let info = purchaserInfo {
                    self.parsePurchaseInfo(info: info)
                }
            }
        }
    }
}
