//
//  UserProfileDTO.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2026.
//

import OpenDota
import Foundation

protocol UserProfileDTO {
    var id: Int { get }
    var avatarfull: String { get }
    var lastLogin: Date? { get }
    var countryCode: String? { get }
    var personaname: String { get }
    var isPlus: Bool { get }
    var profileurl: String? { get }
    var rank: Int? { get }
    var leaderboard: Int? { get }
    var name: String? { get }
}

extension ODUserProfile: UserProfileDTO {
    
    var id: Int {
        profile.accountId
    }
    
    var avatarfull: String {
        profile.avatarfull
    }
    
    var lastLogin: Date? {
        profile.lastLogin
    }
    
    var countryCode: String? {
        profile.loccountrycode
    }
    
    var personaname: String {
        profile.personaname
    }
    
    var isPlus: Bool {
        profile.plus
    }
    
    var profileurl: String? {
        profile.profileurl
    }
    
    var rank: Int? {
        rankTier
    }
    
    var leaderboard: Int? {
        leaderboardRank
    }
    
    var name: String? {
        profile.name
    }
}
