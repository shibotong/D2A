//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import Logging
import UIKit

enum ImageCacheType: String {
    case item
    case avatar
    case ability
    case teamIcon
    case league
}

enum FileExtension: String {
    case jpg
    case png
}

protocol ImageProviding {
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage?
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension)
}

extension ImageProviding {
    func read(type: ImageCacheType, id: String) -> UIImage? {
        return read(type: type, id: id, fileExtension: .jpg)
    }
    
    func save(_ image: UIImage, type: ImageCacheType, id: String) {
        save(image, type: type, id: id, fileExtension: .jpg)
    }
}

class ImageProvider: ImageProviding {
    static let shared = ImageProvider()
    
    private let fileManager: FileManager
    private let logger: Logger
    private let groupName: String
    
    init(fileManager: FileManager = .default,
         groupName: String = GROUP_NAME,
         logger: Logger = D2ALogger.imageCache) {
        self.fileManager = fileManager
        self.groupName = groupName
        self.logger = logger
    }
    
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage? {
        guard let docDir = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupName) else {
            logger.error("Not able to find doc directory with group name: \(groupName)")
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension.rawValue)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension) {
        guard let docDir = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            logger.error("Not able to find doc directory with group name: \(groupName)")
            return
        }
        
        let imageFolder = docDir.appendingPathComponent(type.rawValue)
        do {
            try fileManager.createDirectory(
                at: imageFolder,
                withIntermediateDirectories: true,
                attributes: nil)
            let imageURL = imageFolder.appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
            var imageData: Data?
            if fileExtension == .jpg {
                imageData = image.jpegData(compressionQuality: 1.0)
            }
            if fileExtension == .png {
                imageData = image.pngData()
            }
            try imageData?.write(to: imageURL)
        } catch {
            logger.error("Failed to save image \(id). error: \(error)")
        }
    }
}

class ImageCache {
  
    @available(*, deprecated, message: "Please use protocol instead of using static method")
    static func readImage(type: ImageCacheType,
                          id: String,
                          fileExtension: String = "jpg") -> UIImage? {
        ImageProvider.shared.read(type: type, id: id, fileExtension: FileExtension(rawValue: fileExtension) ?? .jpg)
    }
    
    static func fetchImagePath(type: ImageCacheType, id: String, fileExtension: String = "jpg") -> String? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        return imageURL.path
    }
    
    @available(*, deprecated, message: "Please use protocol instead of using static method")
    static func saveImage(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: String = "jpg") {
        ImageProvider.shared.save(image, type: type, id: id, fileExtension: FileExtension(rawValue: fileExtension) ?? .jpg)
    }
    
    static func docDir(type: ImageCacheType) -> URL? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        return docDir.appendingPathComponent(type.rawValue)
    }
    
    static func loadImage(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
