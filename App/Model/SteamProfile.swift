//
//  SteamProfile.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

struct SteamProfile: TableCodable {
    var rank: Int
    var profile: UserProfile
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = SteamProfile
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case profile
        case rank = "rank_tier"
    }
    
    static let sample = loadProfile()!
}
