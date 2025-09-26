//
//  ODMatch+PickBan.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch {
    struct PickBan: Decodable {
        let isPick: Bool
        let heroID: Int
        let team: Int
        let order: Int
        
        enum CodingKeys: String, CodingKey {
            case isPick = "is_pick"
            case heroID = "hero_id"
            case team
            case order
        }
        
        init(isPick: Bool, heroID: Int, team: Int, order: Int) {
            self.isPick = isPick
            self.heroID = heroID
            self.team = team
            self.order = order
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.PickBan.CodingKeys> = try decoder.container(keyedBy: ODMatch.PickBan.CodingKeys.self)
            self.isPick = try container.decode(Bool.self, forKey: ODMatch.PickBan.CodingKeys.isPick)
            self.heroID = try container.decode(Int.self, forKey: ODMatch.PickBan.CodingKeys.heroID)
            self.team = try container.decode(Int.self, forKey: ODMatch.PickBan.CodingKeys.team)
            self.order = try container.decode(Int.self, forKey: ODMatch.PickBan.CodingKeys.order)
        }
    }
}
