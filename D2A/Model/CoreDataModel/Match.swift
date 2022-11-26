//
//  Match.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData
import SwiftUI

extension Match {
    static func create(_ match: MatchCodable) -> Match {
        let viewContext = PersistenceController.shared.container.viewContext
        Self.delete(id: match.id)
        let matchCoreData = Match(context: viewContext)
        
        matchCoreData.id = match.id.description
        
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
                
        matchCoreData.players = NSSet(array: match.players.compactMap { Player.create($0) })
        matchCoreData.goldDiff = match.goldDiff as [NSNumber]?
        matchCoreData.xpDiff = match.xpDiff as [NSNumber]?
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
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        fetchMatch.predicate = predicate
        
        let results = try? viewContext.fetch(fetchMatch)
        return results?.first
    }
    
    static func delete(id: Int) {
        guard let match = Self.fetch(id: id) else {
            return
        }
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(match)
        print("delete \(id) success")
    }
    
    var allPlayers: [Player] {
        return self.players?.allObjects as? [Player] ?? []
    }
    
    var durationString: String {
        return Int(duration).toDuration
    }
    
    var startTimeString: LocalizedStringKey? {
        return startTime?.toTime
    }
    
    func fetchPlayers(isRadiant: Bool) -> [Player] {
        guard let players = players?.allObjects as? [Player] else {
            return []
        }
        let filteredPlayers = players.filter { isRadiant ? $0.slot <= 127 :  $0.slot > 127 }
        return filteredPlayers
    }
    
//    func fetchKill(isRadiant: Bool) -> Int {
//        if isRadiant {
//            if self.radiantKill != nil {
//                return self.radiantKill!
//            } else {
//                let players = self.fetchPlayers(isRadiant: isRadiant)
//                var kills = 0
//                players.forEach { player in
//                    kills += player.kills
//                }
//                return kills
//            }
//        } else {
//            if self.direKill != nil {
//                return self.direKill!
//            } else {
//                let players = self.fetchPlayers(isRadiant: isRadiant)
//                var countKills = 0
//                players.forEach { player in
//                    countKills += player.kills
//                }
//                return countKills
//            }
//        }
//    }
}
