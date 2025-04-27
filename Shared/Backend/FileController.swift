//
//  FileController.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

class FileController: ObservableObject {
    
    static let shared = FileController()
    static let preview = FileController(imageProvider: MockImageProvider())
    
    let imageProvider: any ImageProviding
    
    init(imageProvider: any ImageProviding = ImageCache.shared) {
        self.imageProvider = imageProvider
    }
}
