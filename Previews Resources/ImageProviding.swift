//
//  ImageProviding.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation
import UIKit

class MockImageProvider: ImageProviding {
    func readImage(type: ImageCacheType, id: String) -> UIImage? {
        switch type {
        case .item:
            return UIImage(named: "empty_item")
        case .avatar:
            return UIImage(named: "avatar1")
        case .ability:
            return UIImage(named: "")
        case .teamIcon:
            return UIImage(named: "")
        case .league:
            return UIImage(named: "")
        case .heroFull:
            return UIImage(named: "1_full")
        case .heroVert:
            return UIImage(named: "1_vert")
        case .heroIcon:
            return UIImage(named: "1_icon")
        case .heroPortrait:
            return UIImage(named: "")
        }
    }
    
    func saveImage(_ image: UIImage, type: ImageCacheType, id: String) {
        return
    }
    
    func loadImage(urlString: String) async -> UIImage? {
        return nil
    }
    
}
