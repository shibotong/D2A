//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class DotaEnvironment: ObservableObject {
    
    @Published var loading = false
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults.standard.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    
    init() {
        self.userIDs = UserDefaults.standard.object(forKey: "dotaArmory.userID") as? [String] ?? ["153041957"]
    }
}
