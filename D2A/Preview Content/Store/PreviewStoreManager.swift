//
//  PreviewStoreManager.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

extension StoreManager {
    static let preview = StoreManager(storeFetcher: PreviewStoreFetcher(), userDefaults: PreviewUserDefaults())
}
