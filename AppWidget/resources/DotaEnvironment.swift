//
//  DotaEnvironment.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 18/9/21.
//

import Foundation
import SwiftUI

class DotaEnvironment {
    
    static var shared = DotaEnvironment()
    
    var userIDs: [String] {
        didSet {
            UserDefaults(suiteName: groupName)!.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    
    init() {
        self.userIDs = UserDefaults(suiteName: groupName)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        if userIDs.isEmpty {
            print("no user")
        } else {
            
        }
    }
}
