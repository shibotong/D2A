//
//  UserDefaults.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import Foundation

extension UserDefaults {
    static let group = UserDefaults(suiteName: GROUP_NAME)!
    
    enum Key: String {
        case searchHistory = "com.shibotong.dotaArmory.searchHistory"
        case stratzToken
        case subscription = "dotaArmory.subscription"
    }
    
    func object(for key: Key) -> Any? {
        return object(forKey: key.rawValue)
    }
    
    func set(_ value: Any?, for key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func string(for key: Key) -> String? {
        string(forKey: key.rawValue)
    }
    
    func bool(for key: Key) -> Bool {
        bool(forKey: key.rawValue)
    }
}
