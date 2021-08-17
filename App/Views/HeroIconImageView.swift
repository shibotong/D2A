//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct HeroIconImageView: View {
    let heroID: Int
    
    var body: some View {
        WebImage(url: computeURL())
            .resizable()
            .renderingMode(.original)
            .indicator(.activity)
            .transition(.fade)
            .aspectRatio(contentMode: .fit)
        
    }
    
    private func computeURL() -> URL? {
        guard let hero = HeroDatabase.shared.fetchHeroWithID(id: heroID) else {
            return nil
        }
        let url = URL(string: "https://api.opendota.com\(hero.icon)")
        return url
    }
}



