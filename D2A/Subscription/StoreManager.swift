//
//  ProductsStore.swift
//  App
//
//  Created by Shibo Tong on 16/9/21.
//

import Foundation
import StoreKit
import WidgetKit
import Logging


class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    @Published var product: Product?
    
    private let storeFetcher: StoreFetching
    private let productIDs: [String]
    private let logger: Logger?
    
    private var purchaseTask: Task<Void, Never>?
    var updateListenerTask: Task<Void, Never>?
    
    init(storeFetcher: StoreFetching = StoreFetcher(),
         productIDs: [String] = ["D2APRO"],
         logger: Logger? = D2ALogger.storeManager) {
        self.storeFetcher = storeFetcher
        self.productIDs = productIDs
        self.logger = logger
        
    }
    
    func setupStore() async {
        logger?.debug("Start setup store manager")
        updateListenerTask = Task {
            await storeFetcher.transactionListener { transaction in
                parsePurchaseInfo(info: transaction)
            }
        }
        await requestProducts()
    }
    
    private func requestProducts() async {
        do {
            guard let product = try await storeFetcher.fetchProducts(productIDs: productIDs).first else {
                logger?.warning("No product found for D2A Pro")
                return
            }
            logger?.trace("Product fetched.")
            self.product = product
        } catch {
            logger?.error("Failed to load store products. \(error)")
        }
    }
    
    func restorePurchase() {
        Task {
            // This call displays a system prompt that asks users to authenticate with their App Store credentials.
            // Call this function only in response to an explicit user action, such as tapping a button.
            try? await AppStore.sync()
        }
    }
    
    private func parsePurchaseInfo(info: Transaction) {
        DispatchQueue.main.async {
            DotaEnvironment.shared.subscriptionStatus = true
            WidgetCenter.shared.reloadAllTimelines()
            print("subscription status \(DotaEnvironment.shared.subscriptionStatus)")
        }
        print("D2A Pro Purchased")
    }
    
    func purchase() {
        purchaseTask?.cancel()
        purchaseTask = Task {
            guard let product else {
                return
            }
            do {
                guard let transaction = try await storeFetcher.purchase(product: product) else {
                    logger?.notice("Pending transaction found. Needs to wait transaction from other source.")
                    return
                }
                guard !Task.isCancelled else {
                    logger?.info("Purchase task is cancelled")
                    return
                }
                parsePurchaseInfo(info: transaction)
                await transaction.finish()
            } catch {
                logger?.warning("Failed to purchase D2APRO. \(error)")
            }
        }
    }
}
