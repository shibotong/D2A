//
//  UserProfile.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation

struct SteamProfile: Codable {
    var profile: UserProfile
    var rank: Int?
    
    enum CodingKeys: String, CodingKey {
        case profile
        case rank = "rank_tier"
    }
    
    static var sample = loadProfile()!
//    func fetchRankString() -> String {
//        var rankTitle = ""
//        var ranktier = ""
//        let str = String(describing: self.rank)
//        if str[0] == "8" {
//            return "SeasonalRankTop0"
//        }
//        
//        return "SeasonalRank\(str[0])-\(str[1])"
//    }
}

struct UserProfile: Codable {
    var id: Int
    
    var avatarfull: String
    var lastLogin: String
    var countryCode: String
    var personaname: String
    var isPlus: Bool
    var profileurl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case avatarfull
        case lastLogin = "last_login"
        case countryCode = "loccountrycode"
        case personaname
        case isPlus = "plus"
        case profileurl
    }
}
