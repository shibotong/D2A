//
//  RecentMatch.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import Foundation
import CoreData

extension RecentMatch {
    static func create(_ match: RecentMatchCodable) throws -> RecentMatch {
        let viewContext = PersistenceController.shared.makeContext()
        let newRecentMatch = fetch(match.id.description, userID: match.playerId?.description ?? "") ?? RecentMatch(context: viewContext)
        newRecentMatch.update(match)
        try viewContext.save()
        return newRecentMatch
    }
    
    static func create(_ matches: [RecentMatchCodable]) async throws {
        let viewContext = PersistenceController.shared.makeContext()
        weak var weakContext = viewContext
        try await viewContext.perform {
            guard let strongContext = weakContext else {
                return
            }
            var insertItems = 0
            let totalItems = matches.count
            let request = NSBatchInsertRequest(entityName: "RecentMatch", managedObjectHandler: { object in
                if insertItems < totalItems {
                    let match = matches[insertItems]
                    let recentMatch = object as! RecentMatch
                    recentMatch.update(match)
                    insertItems += 1
                    print(insertItems)
                    return false
                } else {
                    return true
                }
            })
            request.resultType = .statusOnly
            if let result = try strongContext.execute(request) as? NSBatchInsertResult,
               let success = result.result as? Bool,
               success {
                return
            }
            throw PersistanceError.insertError
        }
    }
    
    func batchInsertItem(amount: Int) async throws -> Bool {
        // 创建私有上下文
        let context = PersistenceController.shared.container.newBackgroundContext()
        return try await context.perform {
            // 已添加的记录数量
            var index = 0
            // 创建 NSBatchInsertRequest ，并声明数据处理闭包。如果 dictionaryHandler 返回 false , Core Data 将继续调用闭包创建数据，直至闭包返回 true 。
            let batchRequest = NSBatchInsertRequest(entityName: "Item", dictionaryHandler: { dict in
                if index < amount {
                    // 创建数据。当前的 Item 只有一个属性 timestamp ，类型为 Date
                    let item = ["timestamp": Date().addingTimeInterval(TimeInterval(index))]
                    dict.setDictionary( item )
                    index += 1
                    return false // 尚未全部完成，仍需继续添加
                } else {
                    return true // index == amout , 已添加了指定数量（ amount ）的数据，结束批量添加操作
                }
            })
            batchRequest.resultType = .statusOnly
            let result = try context.execute(batchRequest) as! NSBatchInsertResult
            return result.result as! Bool
        }
    }
    
    static func fetch(_ matchID: String, userID: String) -> RecentMatch? {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<RecentMatch> = RecentMatch.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id = %@ AND playerId = %@", matchID, userID)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.first
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
        if slot <= 127 {
            return radiantWin
        } else {
            return !radiantWin
        }
    }
    
    var gameMode: GameMode {
        return HeroDatabase.shared.fetchGameMode(id: Int(mode))
    }
    
    var gameLobby: LobbyType {
        return HeroDatabase.shared.fetchLobby(id: Int(lobbyType))
    }
}
