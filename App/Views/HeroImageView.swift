//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

enum HeroImageType {
    case icon, portrait, full, vert
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: HeroDatabase
    let heroID: Int
    let type: HeroImageType
    
    var body: some View {
        if type == .icon || type == .full || type == .vert {
            Image(searchHeroImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            AsyncImage(url: computeURL()) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)// Displays the loaded image.
                } else if phase.error != nil {
                    ActivityIndicator(.constant(true)) // Indicates an error.
                } else {
                    ActivityIndicator(.constant(true)) // Acts as a placeholder.
                }
            }
        }
    }
    
    private func searchHeroImage() -> String {
        guard let hero = HeroDatabase.shared.fetchHeroWithID(id: heroID) else {
            return ""
        }
        switch self.type {
        case .icon:
            let filename = "\(hero.localizedName)_icon"
            return filename
        case .portrait:
            let filename = "\(hero.localizedName)_portrait"
            return filename
        case .full:
            let filename = "\(hero.localizedName)_full"
            return filename
        case .vert:
            let filename = "\(hero.localizedName)_vert"
            return filename
        }
    }
    
    private func computeURL() -> URL? {
        guard let hero = heroData.fetchHeroWithID(id: heroID) else {
            return nil
        }
        switch self.type {
        case .icon:
            let url = URL(string: "https://api.opendota.com\(hero.icon)")
            return url
        case .portrait:
            let name = hero.name.replacingOccurrences(of: "npc_dota_hero_", with: "")
            let url = URL(string: "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/heroes/renders/\(name).png")
            return url
        case .full:
            return nil
        case .vert:
            return nil
        }
    }
}




