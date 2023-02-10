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
                    ProgressView()// Indicates an error.
                } else {
                    ProgressView() // Acts as a placeholder.
                }
            }
        }
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
    
    private func computeURL() -> URL? {
        guard let hero = try? heroData.fetchHeroWithID(id: heroID) else {
            return nil
        }
        switch type {
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
