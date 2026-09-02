//
//  ODUserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Foundation

nonisolated
public struct ODUserProfile: Decodable, Sendable {
    
    public let profile: Profile
    public let rankTier: Int?
    public let leaderboardRank: Int?
    public let computedMmr: Double?
    public let computedMmrTurbo: Double?
    public let aliases: [Alias]?

    public struct Profile: Decodable, Sendable {
        public let accountId: Int
        public let personaname: String
        public let name: String?
        public let plus: Bool
        public let avatar: String
        public let avatarmedium: String
        public let avatarfull: String
        public let profileurl: String
        public let lastLogin: Date?
        public let loccountrycode: String?
    }
    
    public struct Alias: Decodable, Sendable {
        public let personaname: String
        public let nameSince: Date
    }
}
