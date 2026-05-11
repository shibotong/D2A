//
//  MockImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/4/2026.
//

import UIKit

class MockImageProvider: ImageProviding {
    
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage? {
        switch type {
        case .ability:
            return UIImage(named: id)
        default:
            return nil
        }
    }
    
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension) {
        return
    }
    
    func load(urlString: String) async -> UIImage? {
        return nil
    }
    
}
