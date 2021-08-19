//
//  UserProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

struct UserProfile: TableCodable {

    var id: Int
    var avatarfull: String
    var lastLogin: String?
    var countryCode: String?
    var personaname: String
    var isPlus: Bool
    var profileurl: String

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
    }
}
