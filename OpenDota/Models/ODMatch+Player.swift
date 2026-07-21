//
//  ODMatch+Player.swift
//  D2A
//
//  Created by Shibo Tong on 21/7/2026.
//

extension ODMatch {
    public struct Player: Decodable, Sendable {
        public let accountId: Int?
        public let playerSlot: Int
        public let abilityUpgradesArr: [Int]? // An array describing how abilities were upgraded
        public let backpack0: Int?
        public let backpack1: Int?
        public let backpack2: Int?
        public let item0: Int?
        public let item1: Int?
        public let item2: Int?
        public let item3: Int?
        public let item4: Int?
        public let item5: Int?
        public let itemNeutral: Int?
        public let kills: Int?
        public let deaths: Int?
        public let assists: Int?
        public let lastHits: Int?
        public let denies: Int?
        public let goldPerMin: Int?
        public let goldT: [Int]?
        public let netWorth: Int?
        public let xpPerMin: Int?
        public let xpT: [Int]?
        public let heroDamage: Int?
        public let heroHealing: Int?
        public let heroId: Int?
        public let level: Int?
        public let permanentBuffs: [PermanentBuff]?
        public let teamFightParticipation: Double?
        public let towerDamage: Int?
        public let personaname: String?
        public let multiKills: [String: Int]?
        public let rank: Int?
        
        public struct PermanentBuff: Decodable, Sendable {
            public let permanentBuff: Int
            public let stackCound: Int
        }
    }
}
