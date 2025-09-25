//
//  UserDefaults+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import Foundation

extension UserDefaults {
    static let preview = {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, for: .subscription)
        return userDefaults
    }()
}
