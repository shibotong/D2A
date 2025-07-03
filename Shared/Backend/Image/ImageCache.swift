//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

enum ImageCacheType: String {
    case item
    case avatar
    case ability
    case teamIcon
    case league
    case hero
}

protocol ImageProviding {
    func remoteImage(url: String) async -> UIImage?
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension) -> UIImage?
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension)
}

class ImageProvider: ImageProviding {
    
    static let shared = ImageProvider()
    
    func remoteImage(url urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
    
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension = .jpg) -> UIImage? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension) {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            logError("Save image failed due to missing container URL", category: .image)
            return
        }
        
        let imageFolder = docDir.appendingPathComponent(type.rawValue)
        do {
            try FileManager.default.createDirectory(at: imageFolder,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            let imageURL = imageFolder.appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
            var imageData: Data?
            switch fileExtension {
            case .jpg:
                imageData = image.jpegData(compressionQuality: 1.0)
            case .png:
                imageData = image.pngData()
            }
            try imageData?.write(to: imageURL)
        } catch {
            logError("Save image failed. Error: \(error.localizedDescription)", category: .image)
        }
    }
}

class PreviewImageProvider: ImageProviding {
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
