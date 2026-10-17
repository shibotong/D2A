//
//  PreviewStoreManager.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

extension StoreManager {
    static let success = StoreManager(
        product: PreviewStoreProduct.success,
        storeFetcher: PreviewStoreFetcher(),
        userDefaults: PreviewUserDefaults()
    )
    
    static let userCancelled = StoreManager(
        product: PreviewStoreProduct.success,
        storeFetcher: PreviewStoreFetcher(),
        userDefaults: PreviewUserDefaults()
    )
    
    static let pending = StoreManager(
        product: PreviewStoreProduct.success,
        storeFetcher: PreviewStoreFetcher(),
        userDefaults: PreviewUserDefaults()
    )
}
