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
    
    public var key: String?
    public var header: String?
    public var value: String?
    public var generated: Bool?
    
    public func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(header, forKey: "header")
        coder.encode(value, forKey: "value")
        coder.encode(generated, forKey: "generated")
    }
    
    required public init?(coder: NSCoder) {
        self.key = coder.decodeObject(forKey: "key") as? String
        self.header = coder.decodeObject(forKey: "header") as? String
        self.value = coder.decodeObject(forKey: "value") as? String
        self.generated = coder.decodeObject(forKey: "generated") as? Bool
    }
}

@objc(AbilityAttributeTransformer)
final class AbilityAttributeTransformer: NSSecureUnarchiveFromDataTransformer {

   // The name of the transformer. This is what we will use to register the transformer `ValueTransformer.setValueTrandformer(_"forName:)`.
   static let name = NSValueTransformerName(rawValue: "AbilityAttributeTransformer")

   // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
   override static var allowedTopLevelClasses: [AnyClass] {
       return [NSArray.self, AbilityAttribute.self]
   }

   /// Registers the transformer.
   public static func register() {
       let transformer = AbilityAttributeTransformer()
       ValueTransformer.setValueTransformer(transformer, forName: name)
   }
}
