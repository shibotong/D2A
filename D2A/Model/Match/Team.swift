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
    var countryCode: String?
    var url: String?
    var logo: String?
    var baseLogo: String?
    var bannerLogo: String?
    
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
}
