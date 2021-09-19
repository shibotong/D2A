//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI

class DotaEnvironment: ObservableObject {
    static var shared = DotaEnvironment()
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults(suiteName: groupName)!.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    @Published var exceedLimit = false
    
    @Published var addNewAccount = false
    @Published var aboutUs = false
    @Published var subscriptionSheet = false
    
    @Published var subscriptionStatus: Bool {
        didSet {
            UserDefaults(suiteName: groupName)!.set(subscriptionStatus, forKey: "dotaArmory.subscription")
        }
    }
    
    init() {
        self.userIDs = UserDefaults(suiteName: groupName)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        self.subscriptionStatus = UserDefaults(suiteName: groupName)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        if userIDs.isEmpty {
            print("no user")
        } else {
            
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        userIDs.move(fromOffsets: source, toOffset: destination)
    }
    func delete(from indexSet: IndexSet) {
        userIDs.remove(atOffsets: indexSet)
    }
    
    func addUser(userid: String) {
        if self.userIDs.contains(userid) {
            self.userIDs.remove(at: self.userIDs.firstIndex(of: userid)!)
        } else {
            self.userIDs.append(userid)
        }
    }
    
//    func purchaseComplete(state: Bool) {
//        self.subscriptionStatus = state
//        self.subscription = false
//    }
}
