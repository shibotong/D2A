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

     init(imageProvider: ImageProviding = ImageProvider.shared,
          userDefaults: UserDefaults = UserDefaults.group) {
         self.imageProvider = imageProvider
         self.userDefaults = userDefaults
     }

     func refreshImage(type: ImageCacheType, id: String, fileExtension: ImageExtension = .jpg, url: String, refreshTime: Date = Date(),
                       imageHandler: (UIImage) -> Void) async {
         if let localImage = imageProvider.localImage(type: type, id: id, fileExtension: fileExtension) {
             imageHandler(localImage)
         }

         let imageKey = "\(type.rawValue)_\(id)"

         if let savedDate = userDefaults.object(forKey: imageKey) as? Date, !imageNeedsRefresh(lastDate: savedDate, currentDate: refreshTime) {
             return
         }
         guard let remoteImage = await imageProvider.remoteImage(url: url) else {
             return
         }
         imageProvider.saveImage(image: remoteImage, type: type, id: id, fileExtension: fileExtension)
         userDefaults.set(Date(), forKey: imageKey)
         imageHandler(remoteImage)
     }

     private func imageNeedsRefresh(lastDate: Date, currentDate: Date = Date()) -> Bool {
         return lastDate.startOfDay < currentDate.startOfDay
     }

     func localImage(type: ImageCacheType, id: String, fileExtension: ImageExtension) -> UIImage? {
         return imageProvider.localImage(type: type, id: id, fileExtension: fileExtension)
     }
 }
