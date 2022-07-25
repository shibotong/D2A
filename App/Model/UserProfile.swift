//
//  UserProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

struct UserProfile: TableCodable, Identifiable {

    var id: Int
    var avatarfull: String
    
    var lastLogin: String?
    var countryCode: String?
    var personaname: String
    var isPlus: Bool?
    var profileurl: String?
    var rank: Int?
    var leaderboard: Int?
    var name: String?
    static let empty = UserProfile(id: 0, avatarfull: "", lastLogin: nil, countryCode: nil, personaname: "", isPlus: false, profileurl: "", rank: nil, leaderboard: nil)
    static let sample: UserProfile = loadProfile()!

    enum CodingKeys: String, CodingTableKey {
        typealias Root = UserProfile
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "account_id"
        case avatarfull
        case lastLogin = "last_login"
        case countryCode = "loccountrycode"
        case personaname
        case isPlus = "plus"
        case profileurl
        case rank
        case leaderboard
        case name
    }
}
