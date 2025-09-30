//
//  Match+PickBan.swift
//  D2A
//
//  Created by Shibo Tong on 26/9/2025.
//

import Foundation

@objcMembers
public class PickBan: NSObject, NSSecureCoding {
    
    public static let supportsSecureCoding: Bool = true
    
    public var isPick: Bool
    public var heroID: Int
    public var team: Int
    public var order: Int
    
    enum CodingKeys: String, CodingKey {
        case isPick = "is_pick"
        case heroID = "hero_id"
        case team
        case order
    }
    
    init(isPick: Bool, heroID: Int, team: Int, order: Int) {
        self.isPick = isPick
        self.heroID = heroID
        self.team = team
        self.order = order
    }
    
    convenience init?(from json: [String: Any]) {
        guard let isPick = json[CodingKeys.isPick.rawValue] as? Bool,
              let heroID = json[CodingKeys.heroID.rawValue] as? Int,
              let team = json[CodingKeys.team.rawValue] as? Int,
              let order = json[CodingKeys.order.rawValue] as? Int else {
            logError("Failed to decode PickBan from JSON", category: .coredata)
            return nil
        }
        
        self.init(isPick: isPick, heroID: heroID, team: team, order: order)
    }
    
    public required convenience init(coder: NSCoder) {
        let isPick = coder.decodeBool(forKey: CodingKeys.isPick.rawValue)
        let heroID = coder.decodeInteger(forKey: CodingKeys.heroID.rawValue)
        let team = coder.decodeInteger(forKey: CodingKeys.team.rawValue)
        let order = coder.decodeInteger(forKey: CodingKeys.order.rawValue)
        self.init(isPick: isPick, heroID: heroID, team: team, order: order)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(isPick, forKey: CodingKeys.isPick.rawValue)
        coder.encode(heroID, forKey: CodingKeys.heroID.rawValue)
        coder.encode(team, forKey: CodingKeys.team.rawValue)
        coder.encode(order, forKey: CodingKeys.order.rawValue)
    }
}
