//
//  FileImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

import UIKit

protocol FileImageProviding {
    func saveImage(_ image: UIImage, path: URL, name: String, fileExtension: ImageExtension) throws
    func readImage(imageURL: URL) -> UIImage?
}

class FileImageProvider: FileImageProviding {
    static let shared = FileImageProvider()
    
    func saveImage(_ image: UIImage, path: URL, name: String, fileExtension: ImageExtension) throws {
        let imageURL = path.appendingPathComponent("\(name).\(fileExtension)", isDirectory: false)
        var imageData: Data?
        switch fileExtension {
        case .jpg:
            imageData = image.jpegData(compressionQuality: 1.0)
        case .png:
            imageData = image.pngData()
        }
        try imageData?.write(to: imageURL)
    }
    
    func readImage(imageURL: URL) -> UIImage? {
        return UIImage(contentsOfFile: imageURL.path)
    }
}
