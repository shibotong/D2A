//
//  RecentMatch+CoreDataClass.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData

@objc(RecentMatch)
public class RecentMatch: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case duration
        case mode = "game_mode"
        case radiantWin = "radiant_win"
        case slot = "player_slot"
        case heroID = "hero_id"
        case kills
        case deaths
        case assists
        case lobbyType = "lobby_type"
        case startTime = "start_time"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "RecentMatch", in: context) else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.duration = try container.decode(Int16.self, forKey: .duration)
        self.mode = try container.decode(Int16.self, forKey: .mode)
        self.radiantWin = try container.decode(Bool.self, forKey: .radiantWin)
        self.slot = try container.decode(Int16.self, forKey: .slot)
        self.heroID = try container.decode(Int16.self, forKey: .heroID)
        self.kills = try container.decode(Int16.self, forKey: .kills)
        self.deaths = try container.decode(Int16.self, forKey: .deaths)
        self.assists = try container.decode(Int16.self, forKey: .assists)
        self.lobbyType = try container.decode(Int16.self, forKey: .lobbyType)
        self.startTime = try container.decode(Int64.self, forKey: .startTime)
//        self.skill = try container.decode(NSNumber.self, forKey: .skill)
        
    }
    
    func fetchMode() -> GameMode {
        let mode = HeroDatabase.shared.fetchGameMode(id: Int(self.mode))
        return mode
    }
    
    func isPlayerWin() -> Bool {
        return ((self.slot <= 127 && self.radiantWin) || (self.slot > 127 && !self.radiantWin))
    }
}
