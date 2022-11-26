//
//  Match.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

extension Match {
    static func create(_ match: MatchCodable) -> Match {
        let viewContext = PersistenceController.shared.container.viewContext
        let matchCoreData = Self.fetch(id: match.id) ?? Match(context: viewContext)
        
        matchCoreData.id = Int32(match.id)
        
        // Match data
        matchCoreData.direKill = Int16(match.direKill ?? 0)
        matchCoreData.radiantKill = Int16(match.radiantKill ?? 0)
        matchCoreData.duration = Int32(match.duration)
        matchCoreData.radiantWin = match.radiantWin
        
        // Lobby data
        matchCoreData.lobbyType = Int16(match.lobbyType)
        matchCoreData.mode = Int16(match.mode)
        matchCoreData.region = Int16(match.region)
        matchCoreData.skill = Int16(match.skill ?? 0)
        matchCoreData.startTime = Date(timeIntervalSince1970: TimeInterval(match.startTime))
        matchCoreData.players = NSSet(array: match.players.map { Player.create($0) })
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        print("save match successfully \(matchCoreData.id)")
        return matchCoreData
    }
    
    /// Fetch `Match` with `id` in CoreData
    static func fetch(id: Int) -> Match? {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchMatch: NSFetchRequest<Match> = Match.fetchRequest()
        fetchMatch.predicate = NSPredicate(format: "id == %f", id)
        
        let results = try? viewContext.fetch(fetchMatch)
        return results?.first
    }
}
