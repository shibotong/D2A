//
//  ImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

enum ImageCacheType: String {
    case avatar
    case teamIcon
    case league
}

protocol ImageProviding {
    func remoteImage(url: String) async -> UIImage?
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension) -> UIImage?
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension) throws
}

class GameImageProvider: ImageProviding {
    
    static let shared = GameImageProvider()
    
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
    
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension = .jpg) -> UIImage? {
        guard let docDir = documentDirectory else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        return fileImageProvider.readImage(imageURL: imageURL)
    }
    
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension) throws {
        guard let docDir = documentDirectory else {
            logError("Save image failed due to missing container URL", category: .image)
            return
        }
        
        let imageFolder = docDir.appendingPathComponent(type.rawValue)
        try FileManager.default.createDirectory(at: imageFolder,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        try fileImageProvider.saveImage(image, path: imageFolder, name: id, fileExtension: fileExtension)
    }
}

