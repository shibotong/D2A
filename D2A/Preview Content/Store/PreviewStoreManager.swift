//
//  PreviewStoreManager.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

extension StoreManager {
    static let success = StoreManager(
        storeFetcher: PreviewStoreFetcher(products: [PreviewStoreProduct.success]),
        userDefaults: PreviewUserDefaults()
    )
    
    static let userCancelled = StoreManager(
        storeFetcher: PreviewStoreFetcher(products: [PreviewStoreProduct.userCancelled]),
        userDefaults: PreviewUserDefaults()
    )
    
    static let pending = StoreManager(
        storeFetcher: PreviewStoreFetcher(products: [PreviewStoreProduct.pending]),
        userDefaults: PreviewUserDefaults()
    )
}
