//
//  ImageCache.swift
//  D2A
//
//  Created by Shibo Tong on 27/11/2022.
//

import Foundation
import UIKit

protocol ImageProviding {
    func readImage(type: ImageCacheType, id: String) -> UIImage?
    func saveImage(_ image: UIImage, type: ImageCacheType, id: String)
    func loadImage(urlString: String) async -> UIImage?
}

enum ImageCacheType: String {
    case item
    case avatar
    case ability
    case teamIcon
    case league
    
    // Hero Images
    case heroFull
    case heroVert
    case heroIcon
    case heroPortrait
}

class ImageCache: ImageProviding {
    
    static let shared = ImageCache()
    
    func readImage(type: ImageCacheType, id: String) -> UIImage? {
        readImage(type: type, id: id, fileExtension: "jpg")
    }
    
    func saveImage(_ image: UIImage, type: ImageCacheType, id: String) {
        saveImage(image, type: type, id: id, fileExtension: "jpg")
    }
    
    func readImage(type: ImageCacheType,
                   id: String,
                   fileExtension: String = "jpg") -> UIImage? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        let newImage = UIImage(contentsOfFile: imageURL.path)
        return newImage
    }
    
    func saveImage(_ image: UIImage, type: ImageCacheType, id: String, fileExtension: String = "jpg") {
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
            let imageURL = imageFolder.appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
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
    
    func loadImage(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
    
    private func fetchImagePath(type: ImageCacheType, id: String, fileExtension: String = "jpg") -> String? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        let imageURL = docDir.appendingPathComponent(type.rawValue).appendingPathComponent("\(id).\(fileExtension)", isDirectory: false)
        return imageURL.path
    }
    
    private func docDir(type: ImageCacheType) -> URL? {
        guard let docDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME) else {
            return nil
        }
        return docDir.appendingPathComponent(type.rawValue)
    }
}
