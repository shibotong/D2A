//
//  PlayerTransformer.swift
//  D2A
//
//  Created by Shibo Tong on 4/4/2026.
//

import CoreData
import Foundation

@objc(PlayerTransformer)
final class PlayerTransformer: NSSecureUnarchiveFromDataTransformer {
    // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSNumber.self, Player.self, PermanentBuff.self]
    }
}
