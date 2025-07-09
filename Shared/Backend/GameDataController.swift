//
//  GameDataController.swift
//  D2A
//
//  Created by Shibo Tong on 9/7/2025.
//

import CoreData
import Foundation

class GameDataController: ObservableObject {
    
    static let shared = GameDataController()
    
    private let persistanceProvider: PersistanceProviding
    private let openDotaProvider: OpenDotaProviding
    private let refreshHandler: RefreshHandler
    
    init(persistanceProvider: PersistanceProviding = PersistanceProvider.shared,
         openDotaProvider: OpenDotaProviding = OpenDotaProvider.shared,
         refreshHandler: RefreshHandler = .shared) {
        self.persistanceProvider = persistanceProvider
        self.openDotaProvider = openDotaProvider
        self.refreshHandler = refreshHandler
    }
    
    func fetchRecentMatches(for userID: String, context: NSManagedObjectContext, count: Int) -> [RecentMatch] {
        let request = RecentMatch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "player.id = %@", userID)
        request.fetchLimit = count
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func refreshRecentMatches(for userID: String, viewContext: NSManagedObjectContext) async {
        guard await refreshHandler.canRefresh(userid: userID) else {
            return
        }
        let days = calculateDaysSinceLastMatch(userID: userID, context: viewContext)
        let matches = await openDotaProvider.fetchRecentMatches(userID: userID, days: days)
        if matches.count > 50 {
            batchInsertRecentMatches(matches: matches, userID: userID)
        } else {
            insertRecentMatches(matches: matches, userID: userID, context: viewContext)
        }
    }
    
    private func calculateDaysSinceLastMatch(userID: String, context: NSManagedObjectContext) -> Double? {
        guard let latestMatch = RecentMatch.fetch(userID: userID, count: 1, viewContext: context).first else {
            return nil
        }
        
        var days: Double?
        // here should be timeIntervalSinceNow
        if let lastMatchStartTime = latestMatch.startTime?.timeIntervalSinceNow {
            let oneDay: Double = 60 * 60 * 24
            
            // Decrease 1 sec to avoid adding repeated match
            days = -(lastMatchStartTime + 1) / oneDay
        }
        
        return days
    }
    
    private func insertRecentMatches(matches: [RecentMatchCodable], userID: String, context: NSManagedObjectContext) {
        guard let user = UserProfile.fetch(id: userID, viewContext: context) else {
            logError("User profile for \(userID) not found.", category: .coredata)
            return
        }
        for match in matches {
            do {
                let newMatch = RecentMatch(context: context)
                newMatch.update(match)
                newMatch.player = user
                try context.save()
            } catch {
                logError("insert Recent Matches failed. \(error.localizedDescription)", category: .coredata)
                continue
            }
        }
    }
    
    private func batchInsertRecentMatches(matches: [RecentMatchCodable], userID: String) {
        let totalItems = matches.count
        if totalItems <= 50 {
            logError("less than 50 matches should not use batch insert", category: .coredata)
        }
        let bgContext = persistanceProvider.makeContext(author: "RecentMatch")
        guard let user = UserProfile.fetch(id: userID, viewContext: bgContext) else {
            logError("User profile for \(userID) not found.", category: .coredata)
            return
        }
        
        var insertItems = 0
        let request = NSBatchInsertRequest(entity: RecentMatch.entity(), managedObjectHandler: { object in
            guard insertItems < totalItems else {
                return true
            }
            let match = matches[insertItems]
            guard let recentMatch = object as? RecentMatch else {
                return false
            }
            recentMatch.update(match)
            recentMatch.player = user
            insertItems += 1
            return false
        })
        request.resultType = .objectIDs
        do {
            guard let result = try bgContext.execute(request) as? NSBatchInsertResult,
                  let objs = result.result as? [NSManagedObjectID] else {
                logError("Batch insert Recent Matches request failed", category: .coredata)
                return
            }
            let changes: [AnyHashable: Any] = [NSInsertedObjectIDsKey: objs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [persistanceProvider.container.viewContext])
            logDebug("Batch insert Recent Matches success", category: .coredata)
        } catch {
            logError("Batch insert Recent Matches failed. error: \(error.localizedDescription)", category: .coredata)
        }
    }
}
