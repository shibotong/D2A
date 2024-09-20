//
//  HeroTalent.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2024.
//

import Foundation

final public class HeroTalent: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    var slot: Int
    var abilityID: String
    
    enum Key: String {
        case slot, abilityID
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(slot, forKey: Key.slot.rawValue)
        coder.encode(abilityID, forKey: Key.abilityID.rawValue)
    }
    
    convenience required public init?(coder: NSCoder) {
        guard let abilityID = coder.decodeObject(forKey: Key.abilityID.rawValue) as? String else {
            return nil
        }
        let slot = coder.decodeInteger(forKey: Key.slot.rawValue)
        
        self.init(slot: slot, abilityID: abilityID)
    }
    
    init(slot: Int, abilityID: String) {
        self.slot = slot
        self.abilityID = abilityID
    }
}

@objc(HeroTalentTransformer)
final class HeroTalentTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: HeroTalentTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [HeroTalent.self, NSArray.self]
    }
    
    static func register() {
        let transformer = HeroTalentTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
