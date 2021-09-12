//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

enum HeroImageType {
    case icon, portrait
}

struct HeroImageView: View {
    @EnvironmentObject var heroData: HeroDatabase
    let heroID: Int
    let type: HeroImageType
    
    var body: some View {
        WebImage(url: computeURL())
            .resizable()
            .renderingMode(.original)
            .indicator(.activity)
            .transition(.fade)
            .aspectRatio(contentMode: .fit)
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
        }
    }
}




