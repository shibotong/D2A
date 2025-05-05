//
//  Role.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation

@objcMembers
public class Role: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public var roleID: String
    public var level: Int
    
    init(roleID: String, level: Int) {
        self.roleID = roleID
        self.level = level
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(roleID, forKey: "roleID")
        coder.encode(level, forKey: "level")
    }
    
    required public init?(coder: NSCoder) {
        guard let roleID = coder.decodeObject(of: NSString.self, forKey: "roleID") as? String,
        let level = coder.decodeObject(of: NSNumber.self, forKey: "level") as? Int else {
            logError("Failed to decode Role", category: .coredata)
            return nil
        }
        self.roleID = roleID
        self.level = level
    }
}
