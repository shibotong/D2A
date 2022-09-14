//
//  SteamProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

struct SteamProfile: TableCodable {
    var rank: Int?
    var profile: UserProfile
    var leaderboard: Int?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = SteamProfile
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case profile
        case rank = "rank_tier"
        case leaderboard = "leaderboard_rank"
    }
    
    static let sample = loadProfile()!
    
    static let anonymous = SteamProfile(rank: 0, profile: UserProfile(id: 0, avatarfull: "", lastLogin: "", countryCode: "", personaname: "Anonymous", isPlus: false, profileurl: "", rank: 0, leaderboard: nil))
}
      
