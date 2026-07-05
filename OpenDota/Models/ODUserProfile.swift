//
//  ODUserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Foundation

nonisolated
public struct ODUserProfile: Decodable, Sendable {
    
    let profile: Profile
    let rankTier: Int?
    let leaderboardRank: Int?
    let computedMmr: Double?
    let computedMmrTurbo: Double?
    let aliases: [Alias]?

    public struct Profile: Decodable, Sendable {
        let accountId: Int
        let personaname: String
        let name: String?
        let plus: Bool
        let avatar: String
        let avatarmedium: String
        let avatarfull: String
        let profileurl: String
        let lastLogin: Date
        let loccountrycode: String
    }
    
    public struct Alias: Decodable, Sendable {
        let personaname: String
        let nameSince: Date
    }
}
