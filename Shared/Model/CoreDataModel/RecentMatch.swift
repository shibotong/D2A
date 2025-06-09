//
//  RecentMatch.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import CoreData
import Foundation

extension RecentMatch {

    static func create(_ match: RecentMatchCodable, discardable: Bool = false) throws -> RecentMatch
    {
        let viewContext = PersistanceProvider.shared.makeContext(author: "RecentMatch")
        let newRecentMatch =
            fetch(match.id.description, userID: match.playerId?.description ?? "")
            ?? RecentMatch(context: viewContext)
        newRecentMatch.update(match)
        if !discardable {
            try viewContext.save()
            try viewContext.parent?.save()
        }
        return newRecentMatch
    }

    static func create(_ matches: [RecentMatchCodable]) async throws {
        let viewContext = PersistanceProvider.shared.makeContext(author: "RecentMatch")
        weak var weakContext = viewContext
        try await viewContext.perform {
            guard let strongContext = weakContext else {
                return
            }
            var insertItems = 0
            let totalItems = matches.count
            let request = NSBatchInsertRequest(
                entityName: "RecentMatch",
                managedObjectHandler: { object in
                    guard insertItems < totalItems else {
                        return true
                    }
                    let match = matches[insertItems]
                    guard let recentMatch = object as? RecentMatch else {
                        return false
                    }
                    recentMatch.update(match)
                    insertItems += 1
                    return false
                })
            request.resultType = .objectIDs
            if let result = try strongContext.execute(request) as? NSBatchInsertResult,
                let objs = result.result as? [NSManagedObjectID]
            {
                let changes: [AnyHashable: Any] = [NSInsertedObjectIDsKey: objs]
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [PersistanceProvider.shared.container.viewContext])
                return
            }
            throw PersistanceError.insertError
        }
    }

    static func create(
        userID: String,
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
        controller: PersistanceProvider = PersistanceProvider.shared
    ) -> RecentMatch {
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
        match.partySize = partySize
        match.skill = skill

        try? viewContext.save()
        return match
    }

    func batchInsertItem(amount: Int) async throws -> Bool {
        let context = PersistanceProvider.shared.container.newBackgroundContext()
        return try await context.perform {
            var index = 0
            let batchRequest = NSBatchInsertRequest(
                entityName: "Item",
                dictionaryHandler: { dict in
                    guard index < amount else {
                        return true
                    }
                    let item = ["timestamp": Date().addingTimeInterval(TimeInterval(index))]
                    dict.setDictionary(item)
                    index += 1
                    return false
                })
            batchRequest.resultType = .statusOnly
            guard let insertResult = try context.execute(batchRequest) as? NSBatchInsertResult,
                let result = insertResult.result as? Bool
            else {
                throw PersistanceError.insertError
            }
            return result
        }
    }

    static func fetch(_ matchID: String, userID: String) -> RecentMatch? {
        let viewContext = PersistanceProvider.shared.container.viewContext
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id = %@ AND playerId = %@", matchID, userID)

        let results = try? viewContext.fetch(fetchResult)
        return results?.first
    }

    /// Fetch player matches with count.
    /// This function fetches user matches from latest
    /// - parameter userid: Player ID
    /// - parameter count: The number of matches to fetch
    static func fetch(
        userID: String, count: Int,
        viewContext: NSManagedObjectContext = PersistanceProvider.shared.container.viewContext
    ) -> [RecentMatch] {
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

    static func fetch(
        userID: String, on date: Date,
        viewContext: NSManagedObjectContext = PersistanceProvider.shared.container.viewContext
    ) -> [RecentMatch] {
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchResult.sortDescriptors = [sortDescriptor]
        let playerPredicate = NSPredicate(format: "playerId = %@", userID)
        let datePredicate = NSPredicate(
            format: "startTime >= %@ AND startTime <= %@", date.startOfDay as CVarArg,
            date.endOfDay as CVarArg)
        fetchResult.predicate = NSCompoundPredicate(
            type: .and, subpredicates: [playerPredicate, datePredicate])
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
        partySize = Int16(match.partySize ?? 0)
        skill = Int16(match.skill ?? 0)
    }

    var playerWin: Bool {
        guard slot <= 127 else {
            return !radiantWin
        }
        return radiantWin
    }

    var gameMode: GameMode {
        return ConstantsController.shared.fetchGameMode(id: Int(mode))
    }

    var gameLobby: LobbyType {
        return ConstantsController.shared.fetchLobby(id: Int(lobbyType))
    }

    var matchDuration: String {
        return Int(duration).toDuration
    }
}
