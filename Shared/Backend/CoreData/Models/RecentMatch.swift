//
//  RecentMatch.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import Foundation
import CoreData

extension RecentMatch {
    
    static func insertMatches(_ dtos: [any RecentMatchDTO], to userID: String, context: NSManagedObjectContext) throws -> [RecentMatch] {
        let matches = dtos.map { dto in
            let match = RecentMatch(context: context)
            match.map(dto, for: userID)
            return match
        }
        try context.save()
        return matches
    }
    
    static func batchInsertMatches(_ dtos: [any RecentMatchDTO], to userID: String, mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) throws {
        var insertItems = 0
        let totalItems = dtos.count
        let request = NSBatchInsertRequest(entityName: "RecentMatch", managedObjectHandler: { object in
            if insertItems < totalItems {
                let match = dtos[insertItems]
                guard let recentMatch = object as? RecentMatch else {
                    return false
                }
                recentMatch.map(match, for: userID)
                insertItems += 1
                return false
            } else {
                return true
            }
        })
        request.resultType = .objectIDs
        if let result = try backgroundContext.execute(request) as? NSBatchInsertResult,
           let objs = result.result as? [NSManagedObjectID] {
            let changes: [AnyHashable: Any] = [NSInsertedObjectIDsKey: objs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [mainContext])
            return
        }
        throw PersistenceError.insertError
    }
    
    static func create(_ match: RecentMatchCodable, discardable: Bool = false) throws -> RecentMatch {
        let viewContext = PersistenceProvider.shared.makeContext(author: "RecentMatch")
        let newRecentMatch = fetch(match.id.description, userID: match.playerId?.description ?? "") ?? RecentMatch(context: viewContext)
        newRecentMatch.update(match)
        if !discardable {
            try viewContext.save()
            try viewContext.parent?.save()
        }
        return newRecentMatch
    }
    
    static func create(_ matches: [RecentMatchCodable]) async throws {
        let viewContext = PersistenceProvider.shared.makeContext(author: "RecentMatch")
        weak let weakContext = viewContext
        try await viewContext.perform {
            guard let strongContext = weakContext else {
                return
            }
            var insertItems = 0
            let totalItems = matches.count
            let request = NSBatchInsertRequest(entityName: "RecentMatch", managedObjectHandler: { object in
                if insertItems < totalItems {
                    let match = matches[insertItems]
                    guard let recentMatch = object as? RecentMatch else {
                        return false
                    }
                    recentMatch.update(match)
                    insertItems += 1
                    return false
                } else {
                    return true
                }
            })
            request.resultType = .objectIDs
            if let result = try strongContext.execute(request) as? NSBatchInsertResult,
               let objs = result.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSInsertedObjectIDsKey: objs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [PersistenceProvider.shared.container.viewContext])
                return
            }
            throw PersistenceError.insertError
        }
    }
    
    static func create(userID: String,
                       matchID: String,
                       duration: Int32 = 1600,
                       mode: Int16 = 1,
                       radiantWin: Bool = true,
                       slot: Int16 = 1,
                       heroID: Int16 = 1,
                       kills: Int16 = 1,
                       deaths: Int16 = 1,
                       assists: Int16 = 1,
                       lobbyType: Int16 = 1,
                       startTime: Date = Date(),
                       partySize: Int16 = 5,
                       skill: Int16 = 0,
                       controller: PersistenceProvider = PersistenceProvider.shared) -> RecentMatch {
        let viewContext = controller.makeContext(author: "RecentMatch")
        let match = RecentMatch(context: viewContext)
        match.playerId = userID
        match.id = matchID
        
        match.duration = duration
        match.mode = mode
        match.radiantWin = radiantWin
        match.slot = slot
        match.heroID = heroID
        match.kills = kills
        match.deaths = deaths
        match.assists = assists
        match.lobbyType = lobbyType
        match.startTime = startTime
        match.partySize = partySize as NSNumber
        match.skill = skill as NSNumber
        
        try? viewContext.save()
        return match
    }
    
    func batchInsertItem(amount: Int) async throws -> Bool {
        let context = PersistenceProvider.shared.container.newBackgroundContext()
        return try await context.perform {
            var index = 0
            let batchRequest = NSBatchInsertRequest(entityName: "Item", dictionaryHandler: { dict in
                if index < amount {
                    let item = ["timestamp": Date().addingTimeInterval(TimeInterval(index))]
                    dict.setDictionary( item )
                    index += 1
                    return false
                } else {
                    return true
                }
            })
            batchRequest.resultType = .statusOnly
            guard let insertResult = try context.execute(batchRequest) as? NSBatchInsertResult, let result = insertResult.result as? Bool else {
                throw PersistenceError.insertError
            }
            return result
        }
    }
    
    static func fetch(_ matchID: String, userID: String) -> RecentMatch? {
        let viewContext = PersistenceProvider.shared.container.viewContext
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id = %@ AND playerId = %@", matchID, userID)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.first
    }
    
    /// Fetch player matches with count.
    /// This function fetches user matches from latest
    /// - parameter userid: Player ID
    /// - parameter count: The number of matches to fetch
    static func fetch(userID: String, count: Int, viewContext: NSManagedObjectContext = PersistenceProvider.shared.container.viewContext) -> [RecentMatch] {
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchResult.sortDescriptors = [sortDescriptor]
        fetchResult.predicate = NSPredicate(format: "playerId = %@", userID)
        fetchResult.fetchLimit = count
        do {
            let result = try viewContext.fetch(fetchResult)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func fetch(userID: String, on date: Date, viewContext: NSManagedObjectContext = PersistenceProvider.shared.container.viewContext) -> [RecentMatch] {
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchResult.sortDescriptors = [sortDescriptor]
        let playerPredicate = NSPredicate(format: "playerId = %@", userID)
        let datePredicate = NSPredicate(format: "startTime >= %@ AND startTime <= %@", date.startOfDay as CVarArg, date.endOfDay as CVarArg)
        fetchResult.predicate = NSCompoundPredicate(type: .and, subpredicates: [playerPredicate, datePredicate])
        do {
            let result = try viewContext.fetch(fetchResult)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func update(_ match: RecentMatchCodable) {
        id = match.id.description
        playerId = match.playerId?.description ?? ""
        
        duration = Int32(match.duration)
        mode = Int16(match.mode)
        radiantWin = match.radiantWin
        slot = Int16(match.slot)
        heroID = Int16(match.heroID)
        kills = Int16(match.kills)
        deaths = Int16(match.deaths)
        assists = Int16(match.assists)
        lobbyType = Int16(match.lobbyType)
        startTime = Date(timeIntervalSince1970: TimeInterval(match.startTime))
        partySize = Int16(exactly: match.partySize ?? 0) as NSNumber?
        skill = Int16(exactly: match.skill ?? 0) as NSNumber?
    }
    
    func map(_ dto: any RecentMatchDTO, for userID: String) {
        setIfNotEqual(entity: self, path: \.id, value: dto.matchId.description)
        setIfNotEqual(entity: self, path: \.playerId, value: userID)
        setIfNotEqual(entity: self, path: \.duration, value: Int32(dto.duration))
        setIfNotEqual(entity: self, path: \.mode, value: Int16(dto.gameMode))
        setIfNotEqual(entity: self, path: \.radiantWin, value: dto.radiantWin)
        setIfNotEqual(entity: self, path: \.slot, value: Int16(dto.playerSlot))
        setIfNotEqual(entity: self, path: \.heroID, value: Int16(dto.heroId))
        setIfNotEqual(entity: self, path: \.kills, value: Int16(dto.kills))
        setIfNotEqual(entity: self, path: \.deaths, value: Int16(dto.deaths))
        setIfNotEqual(entity: self, path: \.assists, value: Int16(dto.assists))
        setIfNotEqual(entity: self, path: \.lobbyType, value: Int16(dto.lobbyType))
        setIfNotEqual(entity: self, path: \.startTime, value: dto.startTime)
        
        
        // optional values
        setIfNotEqual(entity: self, path: \.partySize, value: dto.partySize as NSNumber?)
        setIfNotEqual(entity: self, path: \.heroVariant, value: dto.heroVariant as NSNumber?)
    }
    
    var playerWin: Bool {
        if slot <= 127 {
            return radiantWin
        } else {
            return !radiantWin
        }
    }
    
    var gameMode: GameMode {
        return GameMode.from(modeId: Int(mode))
    }
    
    var gameLobby: LobbyType {
        return LobbyType.from(id: Int(lobbyType))
    }
    
    var matchDuration: String {
        return Int(duration).toDuration
    }
}
