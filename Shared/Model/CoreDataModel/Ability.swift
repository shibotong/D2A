//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

import Foundation

public class AbilityAttribute: NSObject {
    var key: String?
    var header: String?
    var value: String?
    var generated: Bool?
}

import CoreData

@objc(AbilityAttributeTransformer)
final class AbilityAttributeTransformer: NSSecureUnarchiveFromDataTransformer {

    // The name of the transformer. This is what we will use to register the transformer `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: AbilityAttributeTransformer.self))

    // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
    override static var allowedTopLevelClasses: [AnyClass] {
        return [AbilityAttribute.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = AbilityAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
