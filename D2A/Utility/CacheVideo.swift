//
//  CacheVideo.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2022.
//

import Foundation
import AVKit

class CacheVideo {
    private var cache = NSCache<NSString, AVAsset>()
    private var currentHeroName: String?
    
    static let shared = CacheVideo()
    
    func saveVideo(_ video: AVAsset, key: String, name: String) {
        if name != currentHeroName {
            currentHeroName = name
            cache = NSCache<NSString, AVAsset>()
        }
        cache.setObject(video, forKey: key as NSString)
    }
    
    func getVideo(key: String, name: String) -> AVAsset? {
        if let cacheVideo = cache.object(forKey: key as NSString) {
            return cacheVideo
        } else {
            guard let url = URL(string: key) else { return nil }
            let asset = AVAsset(url: url)
            saveVideo(asset, key: key, name: name)
            return asset
        }
    }
}
