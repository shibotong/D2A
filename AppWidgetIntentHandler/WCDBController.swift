//
//  WCDBController.swift
//  AppWidgetIntentHandler
//
//  Created by Shibo Tong on 19/9/21.
//

import Foundation
import WCDBSwift

class WCDBController {
    static let shared = WCDBController()
    var database: Database
    
    init() {
        let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName)?.appendingPathComponent("WCDB.db")
        database = Database(withFileURL: groupPath!)
        self.createTables()
        
    }
    
    private func createTables() {
        do {
            try database.create(table: "UserProfile", of: UserProfile.self)
        } catch {
            fatalError("cannot create table")
        }
    }
    
    func fetchUserProfile(userid: String) -> UserProfile? {
        do {
            let profile: UserProfile? = try database.getObject(fromTable: "UserProfile", where: UserProfile.Properties.id == Int(userid)!)
            return profile
        } catch {
            print("fetch User profile error")
            return nil
        }
    }
}

