//
//  ArraySecureCodingValueTransformer.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

import Foundation

final class ArrayValueTransformer<T: NSObject & NSSecureCoding>: ValueTransformer {
  override static func transformedValueClass() -> AnyClass { NSArray.self }
  override static func allowsReverseTransformation() -> Bool { true }

  override func transformedValue(_ value: Any?) -> Any? {
    guard let value = value as? [T] else {
      return nil
    }

    do {
      return try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
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
      let nsarray = try NSKeyedUnarchiver.unarchivedObject(
        ofClasses: [NSArray.self, T.self],
        from: data
      )
      return nsarray as? [T]
    } catch {
      logError(
        "Failed to unarchive data: \(data.count) bytes with error: \(error)", category: .coredata)
      return nil
    }
  }

  static func registerTransformer(with transformerName: NSValueTransformerName) {
    let transformer = ArrayValueTransformer<T>()
    ValueTransformer.setValueTransformer(transformer, forName: transformerName)
  }
}
