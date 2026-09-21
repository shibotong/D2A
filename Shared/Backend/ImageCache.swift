//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit
import Mocking

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

@Mocked(compilationCondition: .debug)
protocol ImageProviding {
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage?
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension)
    func load(urlString: String) async -> UIImage?
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
    private let logger: D2ALogger
    private let groupName: String
    
    init(fileManager: FileManager = .default,
         groupName: String = GROUP_NAME,
         logger: D2ALogger = .shared) {
        self.fileManager = fileManager
        self.groupName = groupName
        self.logger = logger
    }
    
    func read(type: ImageCacheType, id: String, fileExtension: FileExtension) -> UIImage? {
        guard let docDir = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupName) else {
            logger.error("Not able to find doc directory with group name: \(groupName)", category: .image)
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension.rawValue)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func save(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: FileExtension) {
        guard let docDir = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            logger.error("Not able to find doc directory with group name: \(groupName)", category: .image)
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
            logger.error("Failed to save image \(id). error: \(error)", category: .image)
        }
    }
    
    func load(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
