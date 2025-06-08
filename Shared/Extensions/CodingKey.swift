//
//  CodingKey.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import CoreData
import Foundation

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

extension JSONDecoder {
  convenience init(context: NSManagedObjectContext) {
    self.init()
    userInfo[.managedObjectContext] = context
  }
}
