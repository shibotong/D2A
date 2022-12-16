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
    
    static func create(id: String,
                       lobbyType: Int16 = 1,
                       mode: Int16 = 1,
                       region: Int16 = 1,
                       skill: Int16 = 1,
                       duration: Int32 = 1800,
                       direKill: Int16 = 30,
                       radiantKill: Int16 = 20,
                       radiantWin: Bool = true,
                       startTime: Date = Date()) {
        let viewContext = PersistenceController.shared.makeContext()
        let matchCoreData = Self.fetch(id: id) ?? Match(context: viewContext)
        matchCoreData.id = id
        matchCoreData.lobbyType = lobbyType
        matchCoreData.mode = mode
        matchCoreData.region = region
        matchCoreData.skill = skill
        matchCoreData.duration = duration
        matchCoreData.direKill = direKill
        matchCoreData.radiantKill = radiantKill
        matchCoreData.radiantWin = radiantWin
        matchCoreData.startTime = startTime
        matchCoreData.players = [
            Player(id: "0", slot: 0),
            Player(id: "1", slot: 1),
            Player(id: "2", slot: 2),
            Player(id: "3", slot: 3),
            Player(id: "4", slot: 4),
            Player(id: "5", slot: 127),
            Player(id: "6", slot: 128),
            Player(id: "7", slot: 129),
            Player(id: "8", slot: 130),
            Player(id: "9", slot: 131)
        ]
        try? viewContext.save()
    }
    
    static func create(_ match: MatchCodable) throws -> Match {
        let viewContext = PersistenceController.shared.makeContext()
        let matchCoreData = Self.fetch(id: match.id.description) ?? Match(context: viewContext)
        matchCoreData.update(match)
        try viewContext.save()
        print("save match successfully \(matchCoreData.id ?? "nil")")
        return matchCoreData
    }
    
    /// Fetch `Match` with `id` in CoreData
    static func fetch(id: String) -> Match? {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchMatch: NSFetchRequest<Match> = Match.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchMatch.predicate = predicate
        
        let results = try? viewContext.fetch(fetchMatch)
        return results?.first
    }
    
    static func delete(id: String) {
        guard let match = Self.fetch(id: id) else {
            return
        }
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(match)
        print("delete \(id) success")
    }
    
    var allPlayers: [Player] {
        return players ?? []
    }
    
    var durationString: String {
        return Int(duration).toDuration
    }
    
    var startTimeString: LocalizedStringKey {
        return startTime?.toTime ?? ""
    }
    
    func fetchPlayers(isRadiant: Bool) -> [Player] {
        guard let players = players else {
            return []
        }
        let filteredPlayers = players.filter { isRadiant ? $0.slot <= 127 : $0.slot > 127 }
        return filteredPlayers
    }
    
    func update(_ match: MatchCodable) {
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
        self.players = match.players.map { Player(player: $0) }
        
        self.goldDiff = match.goldDiff as [NSNumber]?
        self.xpDiff = match.xpDiff as [NSNumber]?
    }
}
