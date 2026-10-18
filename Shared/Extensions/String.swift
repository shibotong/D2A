//
//  String.swift
//  App
//
//  Created by Shibo Tong on 26/8/2022.
//

import Foundation
import SwiftUI

extension String {
    
    static let purchaseKey = "dotaArmory.subscription"
    
    func fetchTalentValue(prefix: String, suffix: String) -> String {
        let value = replacingOccurrences(of: prefix, with: "").replacingOccurrences(of: suffix, with: "")
        return value.count > 5 ? "{value}" : value
    }
}
