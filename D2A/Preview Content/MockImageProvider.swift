//
//  MockImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/4/2026.
//

import UIKit

class MockImageProvider: ImageProviding {
    
    var readImage: UIImage?
    var saveImage: [String: UIImage] = [:]
    var loadImage: UIImage?
    
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage? {
        return readImage
    }
    
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension) {
        saveImage[id] = image
    }
    
    func load(urlString: String) async -> UIImage? {
        return loadImage
    }
}
