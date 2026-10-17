//
//  UserProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation

struct UserProfileCodable: Decodable, Identifiable, UserProfileDTO {
    var lastLogin: Date? {
        return nil
    }

    var id: Int
    var avatarfull: String
    
    var lastLoginString: String?
    var countryCode: String?
    var personaname: String
    var isPlus: Bool
    var profileurl: String?
    var rank: Int?
    var leaderboard: Int?
    var name: String?
    static let empty = UserProfileCodable(id: 0, avatarfull: "", lastLoginString: nil, countryCode: nil, personaname: "", isPlus: false, profileurl: "", rank: nil, leaderboard: nil)
    static let sample: UserProfileCodable = loadProfile()!

    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case avatarfull
        case lastLoginString = "last_login"
        case countryCode = "loccountrycode"
        case personaname
        case isPlus = "plus"
        case profileurl
        case rank
        case leaderboard
        case name
    }
}
