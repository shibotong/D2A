//
//  StoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import StoreKit

protocol StoreFetching: Sendable {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [Product]
}

struct StoreFetcher: StoreFetching {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [Product] {
        return try await Product.products(for: productIDs)
    }
}

