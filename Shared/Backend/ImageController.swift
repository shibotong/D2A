//
//  ImageController.swift
//  D2A
//
//  Created by Shibo Tong on 16/6/2025.
//

import Foundation
import UIKit

class ImageController: ObservableObject {
    
    static let shared = ImageController()
    
    private let imageProvider: GameImageProviding
    private let userDefaults: UserDefaults
    
    private let imageCache: ImageCache
    
    init(imageProvider: GameImageProviding = GameImageProvider.shared,
         userDefaults: UserDefaults = UserDefaults.group,
         imageCache: ImageCache = .shared) {
        self.imageProvider = imageProvider
        self.userDefaults = userDefaults
        self.imageCache = imageCache
    }
    
    func refreshImage(type: GameImageType, id: String, fileExtension: ImageExtension = .jpg,
                      url: String, refreshTime: Date = Date(),
                      imageHandler: (UIImage) -> Void) async {
        let imageKey = "\(type.imageKey)_\(id)"
        
        await refreshImage(imageKey: imageKey, fileExtension: fileExtension, refreshTime: refreshTime, imageHandler: imageHandler) {
            imageProvider.localImage(type: type, id: id, fileExtension: fileExtension)
        } remoteImageHandler: {
            await imageProvider.remoteImage(url: url)
        } saveImageHander: { remoteImage in
            try imageProvider.saveImage(image: remoteImage, type: type, id: id, fileExtension: fileExtension)
        }
    }
    
    private func refreshImage(imageKey: String, fileExtension: ImageExtension = .jpg,
                              refreshTime: Date,
                              imageHandler: (UIImage) -> Void,
                              localImageHandler: () -> UIImage?,
                              remoteImageHandler: () async -> UIImage?,
                              saveImageHander: (UIImage) throws -> Void) async {
        // Check cached image, if have cached image return it
        if let cachedImage = await imageCache.readCache(key: imageKey) {
            imageHandler(cachedImage)
            return
        }
        
        if let localImage = localImageHandler() {
            await imageCache.setCache(key: imageKey, image: localImage)
            imageHandler(localImage)
        }
        
        if let savedDate = userDefaults.object(forKey: imageKey) as? Date, !imageNeedsRefresh(lastDate: savedDate, currentDate: refreshTime) {
            return
        }
        guard let remoteImage = await remoteImageHandler() else {
            return
        }
        imageHandler(remoteImage)
        do {
            try saveImageHander(remoteImage)
            userDefaults.set(Date(), forKey: imageKey)
        } catch {
            logError("Error occured when saving image: \(error.localizedDescription)", category: .image)
        }
    }
    
    private func imageNeedsRefresh(lastDate: Date, currentDate: Date = Date()) -> Bool {
        return lastDate.startOfDay < currentDate.startOfDay
    }
    
    func localImage(type: GameImageType, id: String, fileExtension: ImageExtension) -> UIImage? {
        return imageProvider.localImage(type: type, id: id, fileExtension: fileExtension)
    }
}

actor ImageCache {
    
    static let shared = ImageCache()
    
    private var cache: [String: UIImage] = [:]
    
    func setCache(key: String, image: UIImage) {
        cache[key] = image
    }
    
    func readCache(key: String) -> UIImage? {
        return cache[key]
    }
    
    func resetCache() {
        cache.removeAll()
    }
}
