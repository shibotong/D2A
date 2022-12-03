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
    static func create(_ match: MatchCodable) throws -> Match {
        let viewContext = PersistenceController.shared.makeContext()
        let matchCoreData = Self.fetch(id: match.id) ?? Match(context: viewContext)
        
        try viewContext.save()
        print("save match successfully \(matchCoreData.id ?? "nil")")
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
    
    var startTimeString: LocalizedStringKey {
        return startTime?.toTime ?? ""
    }
    
    func fetchPlayers(isRadiant: Bool) -> [Player] {
        guard let players = players?.allObjects as? [Player] else {
            return []
        }
        let filteredPlayers = players.filter { isRadiant ? $0.slot <= 127 :  $0.slot > 127 }
        return filteredPlayers
    }
    
    func update(match: MatchCodable) {
        self.id = match.id.description
        
        // Match data
        self.direKill = Int16(match.direKill ?? 0)
        self.radiantKill = Int16(match.radiantKill ?? 0)
        self.duration = Int32(match.duration)
        self.radiantWin = match.radiantWin
        
        // Lobby data
        self.lobbyType = Int16(match.lobbyType)
        self.mode = Int16(match.mode)
        self.region = Int16(match.region)
        self.skill = Int16(match.skill ?? 0)
        self.startTime = Date(timeIntervalSince1970: TimeInterval(match.startTime))
                
        if let players = self.players?.allObjects as? [Player] {
            match.players.forEach { playerCodable in
                if let existPlayer = players.first (where: { player in
                    return player.slot == playerCodable.slot
                }) {
                    existPlayer.update(playerCodable)
                } else {
                    let newPlayer = Player.create(playerCodable)
                    self.addToPlayers(newPlayer)
                }
            }
        }
        
        self.goldDiff = match.goldDiff as [NSNumber]?
        self.xpDiff = match.xpDiff as [NSNumber]?
    }
}
