//
//  Role.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import StratzAPI

@objcMembers
public class Role: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    public var roleId: String
    public var level: Int
    
    init(roleId: String, level: Int) {
        self.roleId = roleId
        self.level = level
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(roleId, forKey: "roleId")
        coder.encode(level, forKey: "level")
    }
    
    required public convenience init?(coder: NSCoder) {
        guard let roleId = coder.decodeObject(of: NSString.self, forKey: "roleId") as? String else {
            logError("Failed to decode Role", category: .coredata)
            return nil
        }
        
        let level = coder.decodeInteger(forKey: "level")
        self.init(roleId: roleId, level: level)
    }
}
