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
    
    static func predicate(id: Int) -> NSPredicate {
        return NSPredicate(format: "matchID == %i", id)
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
        case firstBloodTime = "first_blood_time"
        case gameMode = "game_mode"
        case humanPlayers = "human_players"
        case leagueID = "leagueid"
        case lobbyType = "lobby_type"
        case picksBans = "picks_bans"
        case radiantGoldAdv = "radiant_gold_adv"
        case scoreRadiant = "radiant_score"
        case radiantWin = "radiant_win"
        case radiantXpAdv = "radiant_xp_adv"
        case startTime = "start_time"
        case towerStatusDire = "tower_status_dire"
        case towerStatusRadiant = "tower_status_radiant"
        case version
        case skill
    }
    
    func map(from json: [String: Any]) throws {
        guard let matchID = json[CodingKeys.matchID.rawValue] as? Int,
              let radiantWin = json[CodingKeys.radiantWin.rawValue] as? Bool,
              let startTime = json[CodingKeys.startTime.rawValue] as? Int else {
            logError("Not able to decode match. Required value missing", category: .coredata)
            throw D2AError(message: "An error occured when saving match")
        }
        setIfNotEqual(entity: self, path: \.radiantWin, value: radiantWin)
        setIfNotEqual(entity: self, path: \.matchID, value: Int64(matchID))
        let startDate = Date(timeIntervalSince1970: TimeInterval(startTime))
        setIfNotEqual(entity: self, path: \.startTime, value: startDate)
        
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
        let firstBloodTime = json[CodingKeys.firstBloodTime.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.firstBloodTime, value: Int32(firstBloodTime))
        let gameMode = json[CodingKeys.gameMode.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.mode, value: Int16(gameMode))
        let humanPlayers = json[CodingKeys.humanPlayers.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.humanPlayers, value: Int16(humanPlayers))
        let leagueID = json[CodingKeys.leagueID.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.leagueID, value: Int32(leagueID))
        let lobbyType = json[CodingKeys.lobbyType.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.lobbyType, value: Int16(lobbyType))
        if let radiantGoldAdv = json[CodingKeys.radiantGoldAdv.rawValue] as? [NSNumber] {
            setIfNotEqual(entity: self, path: \.goldDiff, value: radiantGoldAdv)
        }
        let radiantScore = json[CodingKeys.scoreRadiant.rawValue] as? Int ?? 0
        setIfNotEqual(entity: self, path: \.radiantKill, value: Int16(radiantScore))
        if let radiantXpAdv = json[CodingKeys.radiantXpAdv.rawValue] as? [NSNumber] {
            setIfNotEqual(entity: self, path: \.xpDiff, value: radiantXpAdv)
        }
        
        // TODO: Team fights
        
        if let towerStatusDire = json[CodingKeys.towerStatusDire.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.towerDire, value: Int16(towerStatusDire))
        }
        
        if let towerStatusRadiant = json[CodingKeys.towerStatusRadiant.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.towerRadiant, value: Int16(towerStatusRadiant))
        }
        
        if let version = json[CodingKeys.version.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.version, value: Int16(version))
        }
        
        // TODO: Team
        // TODO: League
        
        if let skill = json[CodingKeys.skill.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.skill, value: Int16(skill))
        }
        
        // TODO: Players
        // TODO: Patch
        // TODO: Region
        // TODO: Pauses
        
        mapChat(from: json)
        mapDraftTiming(from: json)
        mapPickBan(from: json)
        
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
    
    private func mapPickBan(from json: [String: Any]) {
        guard let picksBansJson = json[CodingKeys.picksBans.rawValue] as? [[String: Any]] else {
            logInfo("No picks bans for this match", category: .coredata)
            return
        }
        let picksBans = picksBansJson.compactMap{ PickBan(from: $0) }
        self.picksBans = picksBans
    }
}
