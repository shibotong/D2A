//
//  Match+Chat.swift
//  D2A
//
//  Created by Shibo Tong on 26/9/2025.
//

import Foundation

@objcMembers
public class Chat: NSObject, NSSecureCoding {
    
    public static let supportsSecureCoding: Bool = true
    
    public var time: Int
    public var type: String
    public var key: String
    public var slot: Int
    public var playerSlot: Int?
    
    enum CodingKeys: String, CodingKey {
        case time
        case type
        case key
        case slot
        case playerSlot = "player_slot"
    }
    
    init(time: Int, type: String, key: String, slot: Int, playerSlot: Int? = nil) {
        self.time = time
        self.type = type
        self.key = key
        self.slot = slot
        self.playerSlot = playerSlot
    }
    
    convenience init?(from json: [String: Any]) {
        guard let time = json[CodingKeys.time.rawValue] as? Int,
              let type = json[CodingKeys.type.rawValue] as? String,
              let key = json[CodingKeys.key.rawValue] as? String,
              let slot = json[CodingKeys.slot.rawValue] as? Int else {
            logError("Failed to decode Chat from json.", category: .coredata)
            return nil
        }
        
        let playerSlot = json[CodingKeys.playerSlot.rawValue] as? Int
        self.init(time: time, type: type, key: key, slot: slot, playerSlot: playerSlot)
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let type = coder.decodeObject(forKey: CodingKeys.type.rawValue) as? String,
                let key = coder.decodeObject(forKey: CodingKeys.key.rawValue) as? String else {
            logError("Failed to decode Chat", category: .coredata)
            return nil
            
        }
        let time = coder.decodeInteger(forKey: CodingKeys.time.rawValue)
        let slot = coder.decodeInteger(forKey: CodingKeys.slot.rawValue)
        let playerSlot = coder.decodeObject(forKey: CodingKeys.playerSlot.rawValue) as? Int
        
        self.init(time: time, type: type, key: key, slot: slot, playerSlot: playerSlot)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(time, forKey: CodingKeys.time.rawValue)
        coder.encode(type, forKey: CodingKeys.type.rawValue)
        coder.encode(key, forKey: CodingKeys.key.rawValue)
        coder.encode(slot, forKey: CodingKeys.slot.rawValue)
        coder.encode(playerSlot, forKey: CodingKeys.playerSlot.rawValue)
    }
}
