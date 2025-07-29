//
//  Talent.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation

@objcMembers
public class Talent: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    public var ability: String
    public var slot: Int
    
    var dictionaries: [String: Any] {
        return [
            "ability": ability,
            "slot": slot
        ]
    }
    
    init(ability: String, slot: Int) {
        self.ability = ability
        self.slot = slot
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(ability, forKey: "ability")
        coder.encode(slot, forKey: "slot")
    }
    
    required public convenience init?(coder: NSCoder) {
        guard let ability = coder.decodeObject(of: NSString.self, forKey: "ability") as? String else {
            logError("Failed to decode Talent", category: .coredata)
            return nil
        }
        
        let slot = coder.decodeInteger(forKey: "slot")
        self.init(ability: ability, slot: slot)
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let talent = object as? Talent else {
            return false
        }
        return self == talent
    }
    
    static func ==(lhs: Talent, rhs: Talent) -> Bool {
        return lhs.ability == rhs.ability && lhs.slot == rhs.slot
    }
}
