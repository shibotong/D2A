//
//  Team.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation
import SwiftUI

struct Team {
    var id: Int
    var name: String
    var countryCode: String?
    var url: String?
    var logo: String?
    var baseLogo: String?
    var bannerLogo: String?
    
    var image: some View {
        AsyncImage(url: URL(string: "https://cdn.stratz.com/images/dota2/teams/\(id).png")) { image in
            image
                .resizable()
        } placeholder: {
            Circle()
                .foregroundColor(.gray)
        }
    }
    
    init?(from team: MatchLiveSubscription.Data.MatchLive.RadiantTeam?) {
        guard let team = team else {
            return nil
        }
        id = team.id
        guard let name = team.name else {
            print("decoding error Team \(id)")
            return nil
        }
        self.name = name
        self.countryCode = team.countryCode
        self.url = team.url
        self.logo = team.logo
        self.baseLogo = team.baseLogo
        self.bannerLogo = team.bannerLogo
    }
    
    init?(from team: MatchLiveSubscription.Data.MatchLive.DireTeam?) {
        guard let team = team else {
            return nil
        }
        id = team.id
        guard let name = team.name else {
            print("decoding error Team \(id)")
            return nil
        }
        self.name = name
        self.countryCode = team.countryCode
        self.url = team.url
        self.logo = team.logo
        self.baseLogo = team.baseLogo
        self.bannerLogo = team.bannerLogo
    }
    
    init(from team: League.LiveMatch.DireTeam) {
        id = team.id
        name = team.name ?? ""
    }
    
    init(from team: League.LiveMatch.RadiantTeam) {
        id = team.id
        name = team.name ?? ""
    }
}
