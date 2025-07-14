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

     static let preview = ImageController(imageProvider: PreviewImageProvider())

     private let imageProvider: ImageProviding
     private let userDefaults: UserDefaults
     
     private let imageCache: ImageCache

     init(imageProvider: ImageProviding = ImageProvider.shared,
          userDefaults: UserDefaults = UserDefaults.group,
          imageCache: ImageCache = .shared) {
         self.imageProvider = imageProvider
         self.userDefaults = userDefaults
         self.imageCache = imageCache
     }

     func refreshImage(type: ImageCacheType, id: String, fileExtension: ImageExtension = .jpg, url: String, refreshTime: Date = Date(),
                       imageHandler: (UIImage) -> Void) async {
         let imageKey = "\(type.rawValue)_\(id)"
         
         // Check cached image, if have cached image return it
         if let cachedImage = await imageCache.readCache(key: imageKey) {
             imageHandler(cachedImage)
             return
         }
         
         if let localImage = imageProvider.localImage(type: type, id: id, fileExtension: fileExtension) {
             await imageCache.setCache(key: imageKey, image: localImage)
             imageHandler(localImage)
         }

         if let savedDate = userDefaults.object(forKey: imageKey) as? Date, !imageNeedsRefresh(lastDate: savedDate, currentDate: refreshTime) {
             return
         }
         guard let remoteImage = await imageProvider.remoteImage(url: url) else {
             return
         }
         imageProvider.saveImage(image: remoteImage, type: type, id: id, fileExtension: fileExtension)
         userDefaults.set(Date(), forKey: imageKey)
         await imageCache.setCache(key: imageKey, image: remoteImage)
         imageHandler(remoteImage)
     }

     private func imageNeedsRefresh(lastDate: Date, currentDate: Date = Date()) -> Bool {
         return lastDate.startOfDay < currentDate.startOfDay
     }

     func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension) -> UIImage? {
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
