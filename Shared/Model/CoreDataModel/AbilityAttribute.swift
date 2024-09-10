//
//  AbilityAttribute.swift
//  D2A
//
//  Created by Shibo Tong on 7/9/2024.
//

import Foundation

final public class AbilityAttribute: NSObject, NSSecureCoding {
    
    let key: String
    let header: String
    let value: String
    let generated: Bool
    
    public static var supportsSecureCoding: Bool = true
    
    enum Key: String, CodingKey {
        case key, header, value, generated
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(key, forKey: Key.key.rawValue)
        coder.encode(header, forKey: Key.header.rawValue)
        coder.encode(value, forKey: Key.value.rawValue)
        coder.encode(generated, forKey: Key.generated.rawValue)
    }
    
    convenience required public init?(coder: NSCoder) {
        guard let key = coder.decodeObject(of: NSString.self, forKey: Key.key.rawValue) as? String,
              let header = coder.decodeObject(of: NSString.self, forKey: Key.header.rawValue) as? String,
              let value = coder.decodeObject(of: NSString.self, forKey: Key.value.rawValue) as? String else {
            return nil
        }
        let generated = coder.decodeBool(forKey: Key.generated.rawValue) as? Bool ?? false
        
        self.init(key: key, header: header, value: value, generated: generated)
    }
    
    init(key: String, header: String, value: String, generated: Bool) {
        self.key = key
        self.header = header
        self.value = value
        self.generated = generated
    }
    
    convenience init?(attribute: AbilityCodableAttribute) {
        guard let key = attribute.key, let header = attribute.header, let value = attribute.value?.transformString() else {
            Logger.shared.log(level: .error, message: "Missing value for ability attribute \(attribute)")
            return nil
        }
        self.init(key: key,
                  header: header,
                  value: value,
                  generated: attribute.generated ?? false)
    }
}

@objc(AbilityAttributeTransformer)
final class AbilityAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: AbilityAttributeTransformer.self))
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [AbilityAttribute.self]
    }
    
    static func register() {
        let transformer = AbilityAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
