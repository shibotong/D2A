//
//  Team.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation

struct Team {
    var id: Int
    var name: String
    var countryCode: String
    var url: String
    var logo: String
    var baseLogo: String
    var bannerLogo: String
    
    init?(from team: MatchLiveSubscription.Data.MatchLive.RadiantTeam?) {
        guard let team = team else {
            return nil
        }
        id = team.id
        guard let name = team.name,
              let countryCode = team.countryCode,
              let url = team.url,
              let logo = team.logo,
              let baseLogo = team.baseLogo,
              let bannerLogo = team.bannerLogo else {
            print("decoding error Team \(id)")
            return nil
        }
        self.name = name
        self.countryCode = countryCode
        self.url = url
        self.logo = logo
        self.baseLogo = baseLogo
        self.bannerLogo = bannerLogo
    }
    
    init?(from team: MatchLiveSubscription.Data.MatchLive.DireTeam?) {
        guard let team = team else {
            return nil
        }
        id = team.id
        guard let name = team.name,
              let countryCode = team.countryCode,
              let url = team.url,
              let logo = team.logo,
              let baseLogo = team.baseLogo,
              let bannerLogo = team.bannerLogo else {
            print("decoding error Team \(id)")
            return nil
        }
        self.name = name
        self.countryCode = countryCode
        self.url = url
        self.logo = logo
        self.baseLogo = baseLogo
        self.bannerLogo = bannerLogo
    }
}
