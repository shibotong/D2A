//
//  FileProvider.swift
//  D2A
//
//  Created by Shibo Tong on 14/6/2025.
//

import Foundation
import UIKit

class FileController: ObservableObject {
    private let imageProvider: ImageProviding
    
    init(imageProvider: ImageProviding = ImageProvider.shared) {
        self.imageProvider = imageProvider
    }
    
    func loadImage(type: ImageCacheType, id: String, fileExtension: String, url: String) async -> UIImage? {
        let image = await imageProvider.loadImage(type: type, id: id, fileExtension: fileExtension, url: url)
        return image
    }
}
