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
            UserDefaults(suiteName: GROUP_NAME)!.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    
    var subscriptionStatus: Bool {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(subscriptionStatus, forKey: "dotaArmory.subscription")
        }
    }
    
    init() {
        self.userIDs = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        self.subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        if userIDs.isEmpty {
            print("no user")
        } else {
            
        }
    }
}
