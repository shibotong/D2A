//
//  UserDefaults.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import Foundation

extension UserDefaults {
    static let group = UserDefaults(suiteName: GROUP_NAME)!
    
    // UserDefaults keys
    static let stratzToken = "stratzToken"
    static let subscription = "dotaArmory.subscription"
}
