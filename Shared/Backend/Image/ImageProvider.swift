//
//  ImageProvider.swift
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
    
    private let documentDirectory: URL?
    private let network: D2ANetworking
    
    init(directory: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME),
         network: D2ANetworking = D2ANetwork.default) {
        documentDirectory = directory
        self.network = network
    }
    
    func remoteImage(url urlString: String) async -> UIImage? {
        return try? await network.remoteImage(urlString)
    }
    
    func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension = .jpg) -> UIImage? {
        guard let docDir = documentDirectory else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func saveImage(image: UIImage, type: ImageCacheType, id: String, fileExtension: ImageExtension) {
        guard let docDir = documentDirectory else {
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

