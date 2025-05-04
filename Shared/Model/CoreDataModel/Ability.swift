//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

import Foundation
import CoreData

public class AbilityAttribute: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    public var key: String
    public var header: String
    public var value: String
    public var generated: Bool?
    
    init?(attribute: ODAbility.Attribute) {
        guard let key = attribute.key, let header = attribute.header, let value = attribute.value?.transformString() else {
            logWarn("Failed to initialize AbilityAttribute with attribute: \(attribute)", category: .opendotaConstant)
            return nil
        }
        self.key = key
        self.header = header
        self.value = value
        self.generated = attribute.generated
        super.init()
    }
    
    init(key: String, header: String, value: String, generated: Bool?) {
        self.key = key
        self.header = header
        self.value = value
        self.generated = generated
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(header, forKey: "header")
        coder.encode(value, forKey: "value")
        coder.encode(generated, forKey: "generated")
    }
    
    required public init?(coder: NSCoder) {
        guard let key = coder.decodeObject(of: NSString.self, forKey: "key") as? String,
        let header = coder.decodeObject(of: NSString.self, forKey: "header") as? String,
        let value = coder.decodeObject(of: NSString.self, forKey: "value") as? String else {
            logError("Failed to decode AbilityAttribute", category: .coredata)
            return nil
        }
        self.key = key
        self.header = header
        self.value = value
        self.generated = coder.decodeObject(of: NSNumber.self, forKey: "generated") as? Bool
    }
}
