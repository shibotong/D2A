//
//  SteamProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation

struct SteamProfile: Decodable {
    var rank: Int?
    var profile: UserProfileCodable
    var leaderboard: Int?
    
    enum CodingKeys: String, CodingKey {
        case profile
        case rank = "rank_tier"
        case leaderboard = "leaderboard_rank"
    }
    
    static let sample = loadProfile()!
    
    static let anonymous = SteamProfile(rank: 0, profile: UserProfileCodable(id: 0, avatarfull: "", lastLogin: "", countryCode: "", personaname: "Anonymous", isPlus: false, profileurl: "", rank: 0, leaderboard: nil), leaderboard: nil)
}
      
