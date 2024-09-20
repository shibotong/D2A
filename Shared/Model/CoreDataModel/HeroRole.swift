//
//  HeroRole.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2024.
//

import Foundation

final public class HeroRole: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    var level: Int
    var roleId: String
    
    enum Key: String {
        case level, roleId
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(level, forKey: Key.level.rawValue)
        coder.encode(roleId, forKey: Key.roleId.rawValue)
    }
    
    convenience required public init?(coder: NSCoder) {
        guard let roleId = coder.decodeObject(forKey: Key.roleId.rawValue) as? String else {
            return nil
        }
        let level = coder.decodeInteger(forKey: Key.level.rawValue)
        
        self.init(level: level, roleId: roleId)
    }
    
    init(level: Int, roleId: String) {
        self.level = level
        self.roleId = roleId
    }
}

@objc(HeroRoleTransformer)
final class HeroRoleTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: HeroRoleTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [HeroRole.self, NSArray.self]
    }
    
    static func register() {
        let transformer = HeroRoleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
