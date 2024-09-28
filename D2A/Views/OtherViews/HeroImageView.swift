//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

enum HeroImageType {
    case icon, portrait, full, vert
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: HeroDatabase
    let heroID: Int
    let type: HeroImageType
    
    @State private var image: UIImage?
    
    init(heroID: Int, type: HeroImageType) {
        self.heroID = heroID
        self.type = type
        image = ImageCache.readImage(type: .hero, id: searchHeroImage(heroID: heroID))
    }
    
    var body: some View {
        ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(searchHeroImage(heroID: 1))
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
        }
        .task(id: heroID) {
            await fetchImage()
        }
    }
    
    private func searchHeroImage(heroID: Int) -> String {
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
    
    private func fetchImage() async {
        guard image == nil else { return }
        
        guard let newImage = await loadImage() else {
            setImage(nil)
            return
        }
        ImageCache.saveImage(newImage, type: .item, id: searchHeroImage(heroID: heroID))
        setImage(newImage)
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = computeURL(),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
    
    @MainActor
    private func setImage(_ image: UIImage?) {
        self.image = image
    }
    
    private func computeURL() -> URL? {
        guard let hero = try? heroData.fetchHeroWithID(id: heroID) else {
            return nil
        }
        let name = hero.name.replacingOccurrences(of: "npc_dota_hero_", with: "")
        switch type {
        case .icon:
            let url = URL(string: "https://cdn.stratz.com/images/dota2/heroes/\(name)_icon.png")
            return url
        case .portrait:
            let url = URL(string: "\(IMAGE_PREFIX)/apps/dota2/videos/dota_react/heroes/renders/\(name).png")
            return url
        case .full:
            let url = URL(string: "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/heroes/\(name).png")
            return url
        case .vert:
            let url = URL(string: "https://cdn.stratz.com/images/dota2/heroes/\(name)_vert.png")
            return url
        }
    }
}
