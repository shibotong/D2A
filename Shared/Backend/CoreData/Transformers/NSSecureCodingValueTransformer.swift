//
//  NSSecureCodingValueTransformer.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

import Foundation

final class NSSecureCodingValueTransformer<T: NSObject & NSSecureCoding>: ValueTransformer {
    override static func transformedValueClass() -> AnyClass { T.self }
    override static func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? T else {
            return nil
        }

        do {
            return try NSKeyedArchiver.archivedData(
                withRootObject: value, requiringSecureCoding: true)
        } catch {
            logError("Failed to archive value: \(value) with error: \(error)", category: .coredata)
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
        } catch {
            logError(
                "Failed to unarchive data: \(data.count) bytes with error: \(error)",
                category: .coredata)
            return nil
        }
    }

    static func registerTransformer(with transformerName: NSValueTransformerName) {
        let transformer = NSSecureCodingValueTransformer<T>()
        ValueTransformer.setValueTransformer(
            transformer, forName: .init(rawValue: transformerName.rawValue))
    }
}
