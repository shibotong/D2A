//
//  ImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

enum GameImageType {
    case avatar
    case teamIcon
    case league
    case item
    case hero(type: HeroImageType)
    case ability
    
    var folder: String {
        switch self {
        case .avatar:
            return "avatar"
        case .teamIcon:
            return "teamIcon"
        case .league:
            return "league"
        case .item:
            return "item"
        case .hero(_):
            return "hero"
        case .ability:
            return "ability"
        }
    }
    
    var imageKey: String {
        switch self {
        case .hero(let type):
            return "hero_\(type.rawValue)"
        default:
            return folder
        }
    }
}

protocol ImageProviding {
    func remoteImage(url: String) async -> UIImage?
    func localImage(type: GameImageType, id: String, fileExtension: ImageExtension) -> UIImage?
    func saveImage(image: UIImage, type: GameImageType, id: String, fileExtension: ImageExtension) throws
}

class ImageProvider: ImageProviding {
    
    static let shared = ImageProvider()
    
    private let documentDirectory: URL?
    private let network: D2ANetworking
    private let fileImageProvider: FileImageProviding
    
    init(directory: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME),
         network: D2ANetworking = D2ANetwork.default,
         fileProvider: FileImageProviding = FileImageProvider.shared) {
        documentDirectory = directory
        self.network = network
        self.fileImageProvider = fileProvider
        self.imageCache = imageCache
        self.userDefaults = userDefaults
    }
    
    func refreshImage(type: GameImageType, id: String, fileExtension: ImageExtension = .jpg,
                      url: String, refreshTime: Date = Date(),
                      imageHandler: (UIImage) -> Void) async throws {
        let imageKey = "\(type.imageKey)_\(id)"
        // Check cached image, if have cached image return it
        if let cachedImage = await imageCache.readCache(key: imageKey) {
            imageHandler(cachedImage)
            return
        }
        
        if let localImage = localImage(type: type, id: id, fileExtension: fileExtension) {
            await imageCache.setCache(key: imageKey, image: localImage)
            imageHandler(localImage)
        }
        
        if let savedDate = userDefaults.object(forKey: imageKey) as? Date, !imageNeedsRefresh(lastDate: savedDate, currentDate: refreshTime) {
            return
        }
        guard let remoteImage = await remoteImage(url: url) else {
            return
        }
        try saveImage(image: remoteImage, type: type, id: id, fileExtension: fileExtension)
        userDefaults.set(Date(), forKey: imageKey)
        await imageCache.setCache(key: imageKey, image: remoteImage)
        imageHandler(remoteImage)
    }
    
    func remoteImage(url urlString: String) async -> UIImage? {
        return try? await network.remoteImage(urlString)
    }
    
    func localImage(type: GameImageType, id: String, fileExtension: ImageExtension = .jpg) -> UIImage? {
        guard let imageFolder = imageFolder(type: type) else {
            return nil
        }
        
        let imageURL = imageFolder.appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        return fileImageProvider.readImage(imageURL: imageURL)
    }
    
    func saveImage(image: UIImage, type: GameImageType, id: String, fileExtension: ImageExtension) throws {
        guard let imageFolder = imageFolder(type: type) else {
            logError("Save image failed due to missing container URL", category: .image)
            return
        }
        
        try FileManager.default.createDirectory(at: imageFolder,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        try fileImageProvider.saveImage(image, path: imageFolder, name: id, fileExtension: fileExtension)
    }
    
    private func imageNeedsRefresh(lastDate: Date, currentDate: Date = Date()) -> Bool {
        return lastDate.startOfDay < currentDate.startOfDay
    }
    
    private func imageFolder(type: GameImageType) -> URL? {
        guard let docDir = documentDirectory else {
            return nil
        }
        var imageFolder = docDir.appendingPathComponent(type.folder)
        switch type {
        case .hero(let type):
            imageFolder = imageFolder.appendingPathComponent(type.rawValue)
        default:
            break
        }
        return imageFolder
    }
}

