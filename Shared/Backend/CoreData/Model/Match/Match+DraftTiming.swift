//
//  Match+DraftTiming.swift
//  D2A
//
//  Created by Shibo Tong on 26/9/2025.
//

import Foundation

@objcMembers
public class DraftTiming: NSObject, NSSecureCoding {
    
    public static let supportsSecureCoding: Bool = true
    
    public var order: Int
    public var pick: Bool
    public var activeTeam: Int
    public var heroID: Int
    public var playerSlot: Int?
    public var extraTime: Int
    public var totalTimeTaken: Int
    
    enum CodingKeys: String, CodingKey {
        case order
        case pick
        case activeTeam = "active_team"
        case heroID = "hero_id"
        case playerSlot = "player_slot"
        case extraTime = "extra_time"
        case totalTimeTaken = "total_time_taken"
    }
    
    init(order: Int, pick: Bool, activeTeam: Int, heroID: Int, playerSlot: Int? = nil, extraTime: Int, totalTimeTaken: Int) {
        self.order = order
        self.pick = pick
        self.activeTeam = activeTeam
        self.heroID = heroID
        self.playerSlot = playerSlot
        self.extraTime = extraTime
        self.totalTimeTaken = totalTimeTaken
    }
    
    convenience init?(from json: [String: Any]) {
        guard let order = json[CodingKeys.order.rawValue] as? Int,
              let pick = json[CodingKeys.pick.rawValue] as? Bool,
              let activeTeam = json[CodingKeys.activeTeam.rawValue] as? Int,
              let heroID = json[CodingKeys.heroID.rawValue] as? Int,
              let extraTime = json[CodingKeys.extraTime.rawValue] as? Int,
              let totalTimeTaken = json[CodingKeys.totalTimeTaken.rawValue] as? Int else {
            logError("Failed to decode DraftTiming from json.", category: .coredata)
            return nil
        }
        let playerSlot = json[CodingKeys.playerSlot.rawValue] as? Int
        self.init(order: order, pick: pick, activeTeam: activeTeam, heroID: heroID, playerSlot: playerSlot, extraTime: extraTime, totalTimeTaken: totalTimeTaken)
    }
    
    public required convenience init?(coder: NSCoder) {
        let order = coder.decodeInteger(forKey: CodingKeys.order.rawValue)
        let pick = coder.decodeBool(forKey: CodingKeys.pick.rawValue)
        let activeTeam = coder.decodeInteger(forKey: CodingKeys.activeTeam.rawValue)
        let heroID = coder.decodeInteger(forKey: CodingKeys.heroID.rawValue)
        let playerSlot = coder.decodeObject(forKey: CodingKeys.playerSlot.rawValue) as? Int
        let extraTime = coder.decodeInteger(forKey: CodingKeys.extraTime.rawValue)
        let totalTimeTaken = coder.decodeInteger(forKey: CodingKeys.totalTimeTaken.rawValue)
        self.init(order: order, pick: pick, activeTeam: activeTeam, heroID: heroID, playerSlot: playerSlot, extraTime: extraTime, totalTimeTaken: totalTimeTaken)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(order, forKey: CodingKeys.order.rawValue)
        coder.encode(pick, forKey: CodingKeys.pick.rawValue)
        coder.encode(activeTeam, forKey: CodingKeys.activeTeam.rawValue)
        coder.encode(heroID, forKey: CodingKeys.heroID.rawValue)
        coder.encode(playerSlot, forKey: CodingKeys.playerSlot.rawValue)
        coder.encode(extraTime, forKey: CodingKeys.extraTime.rawValue)
        coder.encode(totalTimeTaken, forKey: CodingKeys.totalTimeTaken.rawValue)
    }
}

