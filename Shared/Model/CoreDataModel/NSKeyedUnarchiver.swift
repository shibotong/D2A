//
//  NSKeyedUnarchiver.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

import CoreData

extension NSKeyedUnarchiver {
    static func registerClasses() {
        // Register the transformer with the exact name used in the Core Data model
        AbilityAttributeTransformer.register()
    }
}
