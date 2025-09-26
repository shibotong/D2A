//
//  ODMatch+DraftTime.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch {
    struct DraftTime: Decodable {
        let order: Int
        let pick: Bool
        let activeTeam: Int
        let heroID: Int
        let playerSlot: Int
        let extraTime: Int
        let totalTimeTaken: Int
        
        enum CodingKeys: String, CodingKey {
            case order, pick
            case activeTeam = "active_team"
            case heroID = "hero_id"
            case playerSlot = "player_slot"
            case extraTime = "extra_time"
            case totalTimeTaken = "total_time_taken"
        }
    }
}
