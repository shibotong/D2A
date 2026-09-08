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
    
    private static let productIDs: [String] = ["D2APRO"]
    
    @Published var product: StoreProduct?
    @Published var isLoadingProduct: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var errorIsPresented: Bool = false
    @Published var isPurchased: Bool
    @Published var error: D2AError? = nil
    
    private let storeFetcher: StoreFetching
    private let logger: Logger?
    private let widgetCenter: WidgetCenter
    private let notification: D2ANotification
    
    private var purchaseTask: Task<Void, Never>?
    var updateListenerTask: Task<Void, Never>?
    
    init(product: StoreProduct? = nil,
         storeFetcher: StoreFetching = StoreFetcher(),
         userDefaults: UserDefaults? = UserDefaults(suiteName: GROUP_NAME),
         notification: D2ANotification = .default,
         widgetCenter: WidgetCenter = .shared,
         logger: Logger? = D2ALogger.storeManager) {
        self.product = product
        self.storeFetcher = storeFetcher
        self.logger = logger
        self.widgetCenter = widgetCenter
        self.notification = notification
        self.isPurchased = userDefaults?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
    }
    
    func purchase() async {
        isPurchasing = true
        defer { isPurchasing = false }
        guard let product else {
            return
        }
        do {
            let result = try await product.purchase()
            try Task.checkCancellation()
            switch result {
            case .success(let storeVerificationResult):
                await processPurchases(result: storeVerificationResult)
            case .userCancelled:
                setError(StoreError.userCancelled)
            case .pending:
                return
            }
        } catch let error as D2AError {
            setError(error)
            logger?.warning("Failed to purchase D2APRO. \(error)")
        } catch {
            setError(StoreError.unknown)
            logger?.warning("Failed to purchase D2APRO. \(error)")
        }
    }
    
    func restorePurchase() {
        Task {
            // This call displays a system prompt that asks users to authenticate with their App Store credentials.
            // Call this function only in response to an explicit user action, such as tapping a button.
            try? await AppStore.sync()
        }
    }
    
    func setupStore() async {
        logger?.debug("Start setup store manager")
        updateListenerTask = Task {
            await storeFetcher.transactionListener { storeVerificationResult in
                await processPurchases(result: storeVerificationResult)
            }
        }
        await requestProducts()
    }
    
    private func processPurchases(result: StoreVerificationResult) async {
        do {
            let transaction = try result.verify()
            parsePurchaseInfo(info: transaction)
            await transaction.finish()
        } catch {
            setError(error)
        }
    }
    
    private func setError(_ error: D2AError) {
        self.error = error
        errorIsPresented = true
    }
    
    private func requestProducts() async {
        isLoadingProduct = true
        defer { isLoadingProduct = false }
        do {
            guard let product = try await storeFetcher.fetchProducts(productIDs: Self.productIDs).first else {
                logger?.warning("No product found for D2A Pro")
                return
            }
            logger?.trace("Product fetched.")
            self.product = product
        } catch {
            logger?.error("Failed to load store products. \(error)")
        }
    }
    
    private func parsePurchaseInfo(info: StoreTransaction) {
        isPurchased = true
        notification.purchaseCompletion.send(true)
        widgetCenter.reloadAllTimelines()
    }
}
