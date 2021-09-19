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
        let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName)?.appendingPathComponent("WCDB.db")
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WCDB.db")
//        print(groupPath, path)
        database = Database(withFileURL: groupPath!)
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
    
    func fetchRecentMatches(userid: String, offSet: Int = 0) -> [RecentMatch] {
        do {
            let matches: [RecentMatch] = try database.getObjects(fromTable: "RecentMatch",
                                                                 where: RecentMatch.Properties.playerId == Int(userid)!,
                                                                 orderBy: [RecentMatch.Properties.startTime.asOrder(by: .descending)],
                                                                 limit: 100,
                                                                 offset: offSet)
            return matches
        } catch {
            return []
        }
    }
    
    func fetchRecentMatch(userid: String, matchid: Int) -> RecentMatch? {
        do {
            let match: RecentMatch? = try database.getObject(fromTable: "RecentMatch",
                                                                 where: RecentMatch.Properties.playerId == Int(userid)! && RecentMatch.Properties.id == matchid)
            return match
        } catch {
            return nil
        }
    }
    
    func searchMatchOnDate(_ date: Date) -> [RecentMatch] {
        let start = date.startOfDay
        let end = date.endOfDay
        do {
            let matches: [RecentMatch] = try database.getObjects(fromTable: "RecentMatch",
                                                                 where: RecentMatch.Properties.startTime >= start.timeIntervalSince1970 && RecentMatch.Properties.startTime <= end.timeIntervalSince1970,
                                                                 orderBy: [RecentMatch.Properties.startTime.asOrder(by: .descending)])
            return matches
        } catch {
            return []
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
    
    func fetchMatch(matchid: String) -> Match? {
        do {
            let match: Match? = try database.getObject(fromTable: "Match", where: Match.Properties.id == Int(matchid)!)
            return match
        } catch {
            print("fetch match error")
            return nil
        }
    }
    
    func deleteMatch(matchid: String) {
        do {
            try database.delete(fromTable: "Match", where: Match.Properties.id == Int(matchid)!)
        } catch {
            print("cannot delete match")
        }
    }
    
    func deleteRecentMatch(matchid: Int, userid: Int) {
        do {
            try database.delete(fromTable: "RecentMatch", where: RecentMatch.Properties.id == matchid && RecentMatch.Properties.playerId == userid)
        } catch {
            print("cannot delete match")
        }
    }
}
