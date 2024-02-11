//
//  ProductsStore.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import Foundation
import StoreKit
import WidgetKit

fileprivate let productIDs = ["D2APRO"]// ["D2APlusMonthly", "D2APlusQuarterly", "D2APlusAnnually"]

public enum StoreError: Error {
    case failedVerification
}

class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var products: [Product] = []
    
    var updateListenerTask: Task<Void, Error>?
    
    override init() {
        super.init()
        products = []
        updateListenerTask = listenForTransactions()
        Task { [weak self] in
            // initializing store
            await self?.requestProducts()
        }
    }
    
    func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: productIDs)
            DispatchQueue.main.async { [weak self] in
                self?.products = storeProducts
            }
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func restorePurchase() {
        Task {
            // This call displays a system prompt that asks users to authenticate with their App Store credentials.
            // Call this function only in response to an explicit user action, such as tapping a button.
            try? await AppStore.sync()
        }
    }
    
    func parsePurchaseInfo(info: Transaction) {
        DispatchQueue.main.async {
            DotaEnvironment.shared.subscriptionStatus = true
            WidgetCenter.shared.reloadAllTimelines()
            print("subscription status \(DotaEnvironment.shared.subscriptionStatus)")
        }
        print("D2A Pro Purchased")
    }
    
    func purchase() async throws -> Transaction? {
        // Begin a purchase.
        guard let product = products.first else {
            return nil
        }
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            // Deliver content to the user.
            parsePurchaseInfo(info: transaction)

            // Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            guard let self = self else { return }
            // Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Deliver content to the user.
                    self.parsePurchaseInfo(info: transaction)

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }
}
