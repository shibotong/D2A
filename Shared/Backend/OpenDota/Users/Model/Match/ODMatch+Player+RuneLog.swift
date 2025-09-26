//
//  ODMatch+Player+RuneLog.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch.Player {
    struct RuneLog: Decodable {
        let time: Int
        let key: Int
        
        init(time: Int, key: Int) {
            self.time = time
            self.key = key
        }
        
        enum CodingKeys: CodingKey {
            case time
            case key
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.RuneLog.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.RuneLog.CodingKeys.self)
            self.time = try container.decode(Int.self, forKey: ODMatch.Player.RuneLog.CodingKeys.time)
            self.key = try container.decode(Int.self, forKey: ODMatch.Player.RuneLog.CodingKeys.key)
        }
    }
}
