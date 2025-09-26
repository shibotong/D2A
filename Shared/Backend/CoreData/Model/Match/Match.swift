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
        let matchCoreData = fetch(id: match.matchID.description) ?? Match(context: viewContext)
//        matchCoreData.update(match)
        try viewContext.save()
        try viewContext.parent?.save()
        print("save match successfully \(matchCoreData.matchID)")
        return matchCoreData
    }

    /// Fetch `Match` with `id` in CoreData
    static func fetch(id: String) -> Match? {
        let viewContext = PersistanceProvider.shared.container.viewContext
        let fetchMatch: NSFetchRequest<Match> = Match.fetchRequest()
        let predicate = NSPredicate(format: "matchID == %@", id)
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
}

extension Match: Mappable {
    
    enum CodingKeys: String, CodingKey {
        case matchID = "match_id"
        case barracksDire = "barracks_status_dire"
        case barracksRadiant = "barracks_status_radiant"
        case chat
        case cluster
        case scoreDire = "dire_score"
        case draftTiming = "draft_timing"
        case duration
        case engine
    }
    
    func map(from json: [String: Any]) {
        guard let matchID = json[CodingKeys.matchID.rawValue] as? Int else {
            logError("Not able to decode match. missing matchID", category: .coredata)
            return
        }
        setIfNotEqual(entity: self, path: \.matchID, value: Int64(matchID))
        if let barracksDire = json[CodingKeys.barracksDire.rawValue] as? Int,
           let barracksRadiant = json[CodingKeys.barracksRadiant.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.barracksRadiant, value: Int16(barracksRadiant))
            setIfNotEqual(entity: self, path: \.barracksDire, value: Int16(barracksDire))
        }
        let cluster = json[CodingKeys.cluster.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.cluster, value: Int16(cluster))
        let direScore = json[CodingKeys.scoreDire.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.direKill, value: Int16(direScore))
        let duration = json[CodingKeys.duration.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.duration, value: Int32(duration))
        let engine = json[CodingKeys.engine.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.engine, value: Int16(engine))
        
        mapChat(from: json)
        mapDraftTiming(from: json)
        
        
    }
    
    private func mapChat(from json: [String: Any]) {
        guard let chatsJson = json[CodingKeys.chat.rawValue] as? [[String: Any]] else {
            logInfo("No chat for this match", category: .coredata)
            return
        }
        let chats = chatsJson.compactMap{ Chat(from: $0) }
        self.chats = chats
    }
    
    private func mapDraftTiming(from json: [String: Any]) {
        guard let draftsJson = json[CodingKeys.draftTiming.rawValue] as? [[String: Any]] else {
            logInfo("No draft timing for this match", category: .coredata)
            return
        }
        let drafts = draftsJson.compactMap{ DraftTiming(from: $0) }
        self.drafts = drafts
    }
}
