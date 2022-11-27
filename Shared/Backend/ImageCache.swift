//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

enum ImageCacheType {
    case item, avatar
}

class ImageCache: ObservableObject {
    
    static let shared = ImageCache()
    
    private var items: [String: UIImage] = [:]
    private var avatar: [String: UIImage] = [:]
    
    func fetchImage(type: ImageCacheType, id: Int, url: URL?) async throws -> UIImage {
        switch type {
        case .item:
            return try await fetchItemImage(id: id, url: url)
        case .avatar:
            return try await fetchAvatarImage(id: id, url: url)
        }
    }
    
    private func fetchItemImage(id: Int, url: URL?) async throws -> UIImage {
        if let image = items["\(id)"] {
            return image
        } else {
            guard let url = url else {
                throw NSError()
            }
            let image = try await loadImage(url: url)
            items["\(id)"] = image
            return image
        }
    }
    
    private func fetchAvatarImage(id: Int, url: URL?) async throws -> UIImage {
        if let image = avatar["\(id)"] {
            return image
        } else {
            guard let url = url else {
                throw NSError()
            }
            let image = try await loadImage(url: url)
            avatar["\(id)"] = image
            return image
        }
    }
    
    private func loadImage(url: URL) async throws -> UIImage {
        let (imageData, _) = try await URLSession.shared.data(from: url)
        guard let profileImage = UIImage(data: imageData) else {
            throw NSError()
        }
        return profileImage
    }
}
