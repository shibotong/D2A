//
//  ConstantImageProvider.swift
//  D2A
//
//  Created by Shibo Tong on 26/7/2025.
//

import UIKit

protocol ConstantImageProviding {
    func heroImage(type: HeroImageType, heroName: String) -> UIImage?
}

class ConstantImageProvider: ConstantImageProviding {
    
    static let shared = ConstantImageProvider()
    
    func remoteImage(type: HeroImageType, name: String) async -> UIImage? {
        let
    }
    
    func heroImage(type: HeroImageType, heroName: String) -> UIImage {
        
    }
    
    private func imageURL(type: HeroImageType, name: String) -> URL {
        var urlString = ""
        switch type {
        case .icon:
            urlString += "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes/icons/\(name).png"
        case .full:
            urlString += "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            urlString += "https://cdn.stratz.com/images/dota2/heroes/\(name)_vert.png"
        }
        return URL(urlString: urlString)
    }
}
