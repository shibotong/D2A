//
//  NSNumber.swift
//  D2A
//
//  Created by Shibo Tong on 16/12/2022.
//

import Foundation
extension NSNumber: Comparable {
    public static func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
        let lhsInt = Int(truncating: lhs)
        let rhsInt = Int(truncating: rhs)
        return lhsInt < rhsInt
    }
}
