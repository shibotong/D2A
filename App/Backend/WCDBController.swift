//
//  WCDBController.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

class WCDBController {
    static let shared = WCDBController()
    var database: Database
    
    init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WCDB.db")
        
        database = Database(withFileURL: path)
        print(database.canOpen)
        self.createTables()
        
    }
    
    private func createTables() {
        do {
            try database.create(table: "Match", of: Match.self)
            try database.create(table: "UserProfile", of: UserProfile.self)
            try database.create(table: "RecentMatch", of: RecentMatch.self)
        } catch {
            fatalError("cannot create table")
        }
    }
    
    func fetchRecentMatches(userid: String) -> [RecentMatch] {
        do {
            let matches: [RecentMatch] = try database.getObjects(fromTable: "RecentMatch", where: RecentMatch.Properties.playerId == Int(userid)!, orderBy: [RecentMatch.Properties.startTime.asOrder(by: .descending)])
            print(matches.count)
            return matches
        } catch {
            print("no match")
            return []
        }
    }
    
    func fetchUserProfile(userid: String) -> UserProfile? {
        do {
            let profile: UserProfile? = try database.getObject(fromTable: "UserProfile", where: UserProfile.Properties.id == Int(userid)!)
            return profile
        } catch {
            fatalError("fetch user profile error")
        }
    }
    
    func fetchMatch(matchid: String) -> Match? {
        do {
            let match: Match? = try database.getObject(fromTable: "Match", where: Match.Properties.id == Int(matchid)!)
            return match
        } catch {
            fatalError("fetch match error")
        }
    }
    
    func deleteMatch(matchid: String) {
        do {
            try database.delete(fromTable: "Match", where: Match.Properties.id == Int(matchid)!)
        } catch {
            fatalError("cannot delete match")
        }
    }
}
