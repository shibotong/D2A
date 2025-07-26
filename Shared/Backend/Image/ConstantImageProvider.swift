//
//  ConstantImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

import UIKit

enum ConstantImageType: String {
    case item, hero
}

protocol ConstantImageProviding {
    func remoteHeroImage(type: HeroImageType, name: String) async -> UIImage?
    func localHeroImage(type: HeroImageType, name: String) -> UIImage?
}

class ConstantImageProvider: ConstantImageProviding {
    
    static let shared = ConstantImageProvider()
    
    private let network: D2ANetworking
    private let documentDirectory:  URL?
    
    init(network: D2ANetworking = D2ANetwork.default,
         documentDirectory: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME)) {
        self.network = network
        self.documentDirectory = documentDirectory
    }
    
    func remoteHeroImage(type: HeroImageType, name: String) async -> UIImage? {
        let imageURL = imageURL(type: type, name: name)
        return try? await network.remoteImage(imageURL)
    }
    
    func localHeroImage(type: HeroImageType, name: String) -> UIImage? {
        guard let docDir = documentDirectory(type: .hero) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(name).png", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func saveHeroImage(image: UIImage, type: HeroImageType, name: String) {
        guard let docDir = documentDirectory(type: .hero) else {
            logError("Save image failed due to missing container URL", category: .image)
            return
        }
        
        let imageFolder = docDir.appendingPathComponent(type.rawValue)
        do {
            try FileManager.default.createDirectory(at: imageFolder,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
            let imageURL = imageFolder.appendingPathComponent("\(name).png", isDirectory: false)
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
    
    private func documentDirectory(type: ConstantImageType) -> URL? {
        guard let docDic = documentDirectory else {
            return nil
        }
        return docDic.appendingPathComponent(type.rawValue)
    }
    
    private func imageURL(type: HeroImageType, name: String) -> String {
        var urlString = ""
        switch type {
        case .icon:
            urlString += "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes/icons/\(name).png"
        case .full:
            urlString += "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            urlString += "https://cdn.stratz.com/images/dota2/heroes/\(name)_vert.png"
        }
        return urlString
    }
}
