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

