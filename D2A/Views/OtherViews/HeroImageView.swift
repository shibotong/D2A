//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

enum HeroImageType {
    case icon, portrait, full, vert
    
    var cacheType: ImageCacheType {
        switch self {
        case .icon:
                .heroIcon
        case .portrait:
                .heroPortrait
        case .full:
                .heroFull
        case .vert:
                .heroVert
        }
    }
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: HeroDatabase

    let heroID: Int
    let type: HeroImageType

    @State private var image: UIImage?
    
    init(hero: Hero, type: HeroImageType) {
        self.init(heroID: Int(hero.id), type: type)
    }
    
    init(heroID: Int, type: HeroImageType) {
        image = ImageCache.readImage(type: type.cacheType, id: "\(heroID)")
        self.heroID = heroID
        self.type = type
    }
    
    var body: some View {
        imageBody
    }
    
    private var imageBody: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                if type == .icon {
                    Circle()
                        .foregroundColor(Color.label.opacity(0.3))
                } else if type == .full {
                    Image("1_full")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .task {
                            await fetchImage()
                        }
                }
            }
        }
    }
    
    @MainActor
    private func fetchImage() async {
        guard let url = computeURL() else {
            return
        }
        
        guard let image = await ImageCache.loadImage(urlString: url) else {
            return
        }
        
        self.image = image
        ImageCache.saveImage(image, type: type.cacheType, id: "\(heroID)")
    }
    
    private func searchHeroImage() -> String {
        switch type {
        case .icon:
            let filename = "\(heroID.description)_icon"
            return filename
        case .portrait:
            let filename = "\(heroID.description)_portrait"
            return filename
        case .full:
            let filename = "\(heroID.description)_full"
            return filename
        case .vert:
            let filename = "\(heroID.description)_vert"
            return filename
        }
    }
    
    private func computeURL() -> String? {
        guard let hero = try? heroData.fetchHeroWithID(id: heroID) else {
            return nil
        }
        let name = hero.name.replacingOccurrences(of: "npc_dota_hero_", with: "")
        switch type {
        case .icon:
            return "https://api.opendota.com\(hero.icon)"
        case .portrait:
            return "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/heroes/renders/\(name).png"
        case .full:
            return "\(IMAGE_PREFIX)/apps/dota2/images/dota_react/heroes/\(name).png"
        case .vert:
            return nil
        }
    }
}
