//
//  ODMatch+Player+BuyBack.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch.Player {
    struct BuyBack: Decodable {
        let time: Int
        let slot: Int
        let playerSlot: Int
        
        enum CodingKeys: String, CodingKey {
            case time, slot
            case playerSlot = "player_slot"
        }
        
        init(time: Int, slot: Int, playerSlot: Int) {
            self.time = time
            self.slot = slot
            self.playerSlot = playerSlot
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.BuyBack.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.BuyBack.CodingKeys.self)
            self.time = try container.decode(Int.self, forKey: ODMatch.Player.BuyBack.CodingKeys.time)
            self.slot = try container.decode(Int.self, forKey: ODMatch.Player.BuyBack.CodingKeys.slot)
            self.playerSlot = try container.decode(Int.self, forKey: ODMatch.Player.BuyBack.CodingKeys.playerSlot)
        }
    }
}
