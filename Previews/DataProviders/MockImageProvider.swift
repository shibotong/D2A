//
//  MockImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

import UIKit

class MockImageProvider: ImageProviding {
    func remoteImage(url: String) async -> UIImage? {
        return loadImage()
    }
    
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension) -> UIImage? {
        return loadImage(type: type)
    }
    
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension) {
        return
    }
    
    private func loadImage(type: ImageCacheType = .item) -> UIImage {
        switch type {
        case .item:
            return UIImage(named: "preview_item")!
        case .avatar:
            return UIImage(named: "preview_avatar")!
        case .ability:
            return UIImage(named: "preview_ability")!
        case .teamIcon:
            return UIImage(named: "preview_avatar")!
        case .league:
            return UIImage(named: "preview_league")!
        case .hero:
            return UIImage(named: "preview_hero")!
        }
    }
}
