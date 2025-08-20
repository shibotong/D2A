//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 20/8/2025.
//

import UIKit

actor ImageCache {
    
    static let shared = ImageCache()
    
    private var cache: [String: UIImage] = [:]
    
    func setCache(key: String, image: UIImage) {
        cache[key] = image
    }
    
    func readCache(key: String) -> UIImage? {
        return cache[key]
    }
    
    func resetCache() {
        cache.removeAll()
    }
}
