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
    case ability = "ability"
}

class ImageCache: ObservableObject {
    
    static func readImage(type: ImageCacheType, id: String) -> UIImage? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).jpg", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    static func saveImage(_ image: UIImage, type: ImageCacheType, id: String) {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            print("save image error")
            return
        }
        
        let imageFolder = docDir.appendingPathComponent(type.rawValue)
        do {
            try FileManager.default
                .createDirectory(
                    at: imageFolder,
                    withIntermediateDirectories: true,
                    attributes: nil)
            let imageURL = imageFolder.appendingPathComponent("\(id).jpg", isDirectory: false)
            let imageData = image.jpegData(compressionQuality: 1.0)
            try imageData?.write(to: imageURL)
        } catch {
            print(error)
            // log any errors
        }
    }
}
