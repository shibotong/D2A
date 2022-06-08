//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI

enum TabSelection {
    case home, hero, search, setting
}

class DotaEnvironment: ObservableObject {
    static var shared = DotaEnvironment()
    static var preview: DotaEnvironment = {
        let env = DotaEnvironment()
//        env.userIDs = ["125581247", "177416702", "153041957"]
        env.userIDs = []
        env.registerdID = ""
//        env.registerdID = "153041957"
        return env
    }()
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    
    @Published var registerdID: String {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(registerdID, forKey: "dotaArmory.registerdID")
        }
    }
    @Published var exceedLimit = false
    
    @Published var addNewAccount = false
    @Published var aboutUs = false
    @Published var subscriptionSheet = false
    
    @Published var subscriptionStatus: Bool {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(subscriptionStatus, forKey: "dotaArmory.subscription")
        }
    }
    
    @Published var selectedAbility: AbilityContainer?
    @Published var selectedTab: TabSelection = .home
    
    init() {
        self.userIDs = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        self.subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        self.registerdID = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.registerdID") as? String ?? ""
        if userIDs.isEmpty {
            print("no user")
        } else {
            
        }
        if registerdID == "" {
            print("no registered")
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        userIDs.move(fromOffsets: source, toOffset: destination)
    }
    func delete(from indexSet: IndexSet) {
        userIDs.remove(atOffsets: indexSet)
    }
    
    func delete(userID: String) {
        if let index = userIDs.firstIndex(of: userID) {
            self.userIDs.remove(at: index)
        }
    }
    
    func addUser(userid: String) {
        if self.userIDs.contains(userid) {
            self.userIDs.remove(at: self.userIDs.firstIndex(of: userid)!)
        } else {
            self.userIDs.append(userid)
        }
    }
    
    @MainActor
    func registerUser(userid: String) {
        self.registerdID = userid
    }
    
//    func purchaseComplete(state: Bool) {
//        self.subscriptionStatus = state
//        self.subscription = false
//    }
}
