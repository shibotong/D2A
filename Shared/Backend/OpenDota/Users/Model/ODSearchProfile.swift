//
//  ODSearchProfile.swift
//  D2A
//
//  Created by Shibo Tong on 23/8/2025.
//

import Foundation

struct ODSearchProfile: Decodable, Identifiable {
    
    var id: Int {
        accountID
    }
    
    let accountID: Int
    let personaname: String
    let avatarFull: String

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case personaname
        case avatarFull = "avatarfull"
    }
}
