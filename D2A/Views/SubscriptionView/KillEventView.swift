//
//  KillEventView.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import SwiftUI

struct KillEventView: View {
    
    @EnvironmentObject var database: HeroDatabase
    
    var kill: Int
    var died: [Int]?
    var isRadiant: Bool
    var isKill: Bool
    var time: Int
    
    var body: some View {
        HStack {
            if !isRadiant {
                MatchLiveTimeLabel(time: time)
                Spacer()
            } else {
                HeroImageView(heroID: kill, type: .icon)
                    .frame(width: 30, height: 30)
            }
            if let died = died {
                VStack(alignment: isRadiant ? .leading : .trailing, spacing: 2) {
                    ForEach(died, id: \.self) { diedHeroID in
                        let heroName = try? database.fetchHeroWithID(id: diedHeroID).localizedName
                        HStack(spacing: 2) {
                            Text("Killed")
                                .font(.custom(fontString, size: 12))
                                .foregroundColor(.secondaryLabel)
                            HeroImageView(heroID: diedHeroID, type: .icon)
                                .frame(width: 15, height: 15)
                            Text("\(heroName ?? "a hero")")
                                .font(.custom(fontString, size: 12)).bold()
                        }
                    }
                }
            } else {
                Text(isKill ? "Killed a hero" : "has Died")
                    .font(.custom(fontString, size: 12))
                    .foregroundColor(.secondaryLabel)
            }
            if isRadiant {
                Spacer()
                MatchLiveTimeLabel(time: time)
            } else {
                HeroImageView(heroID: kill, type: .icon)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct KillEventView_Previews: PreviewProvider {
    static var previews: some View {
        KillEventView(kill: 1, isRadiant: true, isKill: false, time: 100)
    }
}
