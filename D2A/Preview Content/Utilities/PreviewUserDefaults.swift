//
//  PreviewUserDefaults.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

import Foundation

nonisolated
class PreviewUserDefaults: UserDefaults {
        
    override func set(_ value: Any?, forKey defaultName: String) {
        return
    }
    
    override func value(forKey key: String) -> Any? {
        return nil
    }
}
