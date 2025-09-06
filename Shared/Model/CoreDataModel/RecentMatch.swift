//
//  RecentMatch.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import CoreData
import Foundation

extension RecentMatch {

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
        userID: String,
        count: Int? = nil,
        on date: Date? = nil,
        viewContext: NSManagedObjectContext = PersistanceProvider.shared.container.viewContext
    ) -> [RecentMatch] {
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchResult.sortDescriptors = [sortDescriptor]
        let userPredicate = NSPredicate(format: "userID = %d", Int(userID)!)
        
        if let count {
            fetchResult.fetchLimit = count
        }
        var predicates = [userPredicate]
        if let date {
            let datePredicate = NSPredicate(
                format: "startTime >= %@ AND startTime <= %@", date.startOfDay as CVarArg,
                date.endOfDay as CVarArg)
            predicates.append(datePredicate)
        }
        fetchResult.predicate = NSCompoundPredicate(
            type: .and, subpredicates: predicates)
        do {
            let result = try viewContext.fetch(fetchResult)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func update(_ match: RecentMatchCodable) {
        matchID = Int64(match.id)

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

    var gameMode: GameMode? {
        return ConstantsController.shared.fetchGameMode(id: Int(mode))
    }

    var gameLobby: LobbyType {
        return ConstantsController.shared.fetchLobby(id: Int(lobbyType))
    }

    var matchDuration: String {
        return Int(duration).toDuration
    }
}
