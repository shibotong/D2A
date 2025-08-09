//
//  MockImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

import UIKit

class MockImageProvider: ImageProviding {
    func remoteImage(url: String) async -> UIImage? {
        return nil
    }
    
    func localImage(type: GameImageType, id: String, fileExtension: ImageExtension) -> UIImage? {
        return loadImage(type: type)
    }
    
    func saveImage(image: UIImage, type: GameImageType, id: String, fileExtension: ImageExtension) {
        return
    }
    
    private func loadImage(type: GameImageType = .item) -> UIImage {
        switch type {
        case .avatar:
            UIImage(named: "preview_avatar")!
        case .teamIcon:
            UIImage(named: "preview_avatar")!
        case .league:
            UIImage(named: "preview_league")!
        case .item:
            UIImage(named: "preview_item")!
        case .hero(let type):
            UIImage(named: "antimage_\(type)")!
        case .ability:
            UIImage(named: "preview_ability")!
        }
    }
}
