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
}

protocol ImageProviding {
    func loadImage(type: ImageCacheType, id: String, fileExtension: String, url: String) async -> UIImage?
}

class ImageProvider: ImageProviding {
    static let shared = ImageProvider()
    
    func loadImage(type: ImageCacheType, id: String, fileExtension: String, url: String) async -> UIImage? {
        if let savedImage = ImageCache.readImage(type: type, id: id, fileExtension: fileExtension) {
            return savedImage
        }
        
        guard let remoteImage = await ImageCache.loadImage(urlString: url) else {
            return nil
        }
        ImageCache.saveImage(remoteImage, type: type, id: id, fileExtension: fileExtension)
        return remoteImage
    }
}

class ImageCache: ObservableObject {

    static func readImage(
        type: ImageCacheType,
        id: String,
        fileExtension: String = "jpg"
    ) -> UIImage? {
        guard
            let docDir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: GROUP_NAME)
        else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent(
            "\(id).\(fileExtension)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }

    static func fetchImagePath(type: ImageCacheType, id: String, fileExtension: String = "jpg")
        -> String?
    {
        guard
            let docDir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: GROUP_NAME)
        else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent(
            "\(id).\(fileExtension)", isDirectory: false)
        return imageURL.path
    }

    static func saveImage(
        _ image: UIImage, type: ImageCacheType, id: String, fileExtension: String = "jpg"
    ) {
        guard
            let docDir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: GROUP_NAME)
        else {
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
            let imageURL = imageFolder.appendingPathComponent(
                "\(id).\(fileExtension)", isDirectory: false)
            var imageData: Data?
            if fileExtension == "jpg" {
                imageData = image.jpegData(compressionQuality: 1.0)
            }
            if fileExtension == "png" {
                imageData = image.pngData()
            }
            try imageData?.write(to: imageURL)
        } catch {
            print(error)
            // log any errors
        }
    }

    static func docDir(type: ImageCacheType) -> URL? {
        guard
            let docDir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: GROUP_NAME)
        else {
            return nil
        }
        return docDir.appendingPathComponent(type.rawValue)
    }

    static func loadImage(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
            let (newImageData, _) = try? await URLSession.shared.data(from: url),
            let newImage = UIImage(data: newImageData)
        else {
            return nil
        }
        return newImage
    }
}
