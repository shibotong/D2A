//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

enum ImageCacheType: String {
    case item = "item"
    case avatar = "avatar"
}

class ImageCache: ObservableObject {
    
    static func readImage(type: ImageCacheType, id: String) -> UIImage? {
        guard let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).jpg")
        print(imageURL)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    static func saveImage(_ image: UIImage, type: ImageCacheType, id: String) {
        guard let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            print("save image error")
            return
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).jpg")
        let imageData = image.jpegData(compressionQuality: 1.0)
        try? imageData?.write(to: imageURL)
    }
}
