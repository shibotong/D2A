//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class DotaEnvironment: ObservableObject {
    
    static var shared = DotaEnvironment()
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults.standard.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    @Published var exceedLimit = false
    
    @Published var addNewAccount = false
    @Published var aboutUs = false
    
    init() {
        self.userIDs = UserDefaults.standard.object(forKey: "dotaArmory.userID") as? [String] ?? []
        if userIDs.isEmpty {
            print("no user")
        } else {
//            self.loadUser(id: userIDs.first!)
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
}
