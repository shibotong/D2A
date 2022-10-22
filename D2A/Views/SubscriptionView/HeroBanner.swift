//
//  HeroBanner.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct HeroBanner: View {
    
    var players: [MatchLiveSubscription.Data.MatchLive.Player?] = []
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.gray).opacity(0.1))
            VStack(spacing: 10) {
                buildHeroIcon(isRadiant: true)
                buildHeroIcon(isRadiant: false)
            }
            .padding(10)
        }
        .frame(height: 90)
    }
    
    @ViewBuilder private func buildHeroIcon(isRadiant: Bool) -> some View {
        let heroes = players.filter { player in
            return player?.isRadiant == isRadiant
        }.compactMap { player in
            return player?.heroId
        }
        
        HStack {
            ForEach(heroes, id: \.self) { heroID in
                HeroImageView(heroID: Int(heroID), type: .icon)
            }
        }
    }
}


struct HeroBanner_Previews: PreviewProvider {
    static var previews: some View {
        HeroBanner()
    }
}
