//
//  ProductsStore.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var products: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    override init() {
        super.init()
        products = []
        Task {
            // initializing store
            await self.requestProducts()
        }
//        self.getPurchaserInfo()
    }
    
    func requestProducts() async {
        do {
            //Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: productIDs)
            DispatchQueue.main.async {
                self.products = storeProducts
            }
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func restorePurchase() {
//        Purchases.shared.restoreTransactions { purchaserInfo, error in
//            if let info = purchaserInfo {
//                self.parsePurchaseInfo(info: info)
//            }
//        }
    }
    
    func parsePurchaseInfo(info: Transaction) {
//        if let active = info.entitlements["D2APlus"]?.isActive {
//            print("subscription status \(active)")
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yy-MM-dd hh:mm:ss"
//            print("expire time \(String(describing: formatter.string(for: info.entitlements["D2APlus"]?.expirationDate)))")
//            DotaEnvironment.shared.subscriptionStatus = active
//        } else {
//            DotaEnvironment.shared.subscriptionStatus = false
//        }
        DotaEnvironment.shared.subscriptionStatus = true
        print("D2A Pro Purchased")
    }
    
    func purchase() async throws -> Transaction? {
        //Begin a purchase.
        let product = self.products.first!
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            //Deliver content to the user.
            self.parsePurchaseInfo(info: transaction)

            //Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver content to the user.
                    self.parsePurchaseInfo(info: transaction)

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            //If the transaction is verified, unwrap and return it.
            return safe
        }
    }
}
