//
//  Match.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import CoreData
import Foundation
import SwiftUI

extension Match {
    static func create(_ match: ODMatch) throws -> Match {
        let viewContext = PersistanceProvider.shared.makeContext(author: "Match")
        let matchCoreData = fetch(id: match.id.description) ?? Match(context: viewContext)
        matchCoreData.update(match)
        try viewContext.save()
        try viewContext.parent?.save()
        print("save match successfully \(matchCoreData.matchID)")
        return matchCoreData
    }

    /// Fetch `Match` with `id` in CoreData
    static func fetch(id: String) -> Match? {
        let viewContext = PersistanceProvider.shared.container.viewContext
        let fetchMatch: NSFetchRequest<Match> = Match.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchMatch.predicate = predicate

        let results = try? viewContext.fetch(fetchMatch)
        return results?.first
    }

    static func delete(id: String) {
        guard let match = fetch(id: id) else {
            return
        }
        let viewContext = PersistanceProvider.shared.container.viewContext
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

    func update(_ match: ODMatch) {
        matchID = Int64(match.id)

        // Match data
        direKill = Int16(match.direKill ?? 0)
        radiantKill = Int16(match.radiantKill ?? 0)
        duration = Int32(match.duration)
        radiantWin = match.radiantWin

        // Lobby data
        lobbyType = Int16(match.lobbyType)
        mode = Int16(match.mode)
        region = Int16(match.region)
        skill = Int16(match.skill ?? 0)
        startTime = Date(timeIntervalSince1970: TimeInterval(match.startTime))
        players = match.players.map { Player(player: $0) }

        goldDiff = match.goldDiff as [NSNumber]?
        xpDiff = match.xpDiff as [NSNumber]?
    }
}
