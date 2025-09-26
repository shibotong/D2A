//
//  ODMatch+Player+KillLog.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch.Player {
    struct KillLog: Decodable {
        let time: Int
        let key: String
        
        enum CodingKeys: CodingKey {
            case time
            case key
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.KillLog.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.KillLog.CodingKeys.self)
            self.time = try container.decode(Int.self, forKey: ODMatch.Player.KillLog.CodingKeys.time)
            self.key = try container.decode(String.self, forKey: ODMatch.Player.KillLog.CodingKeys.key)
        }
        
        init(time: Int, key: String) {
            self.time = time
            self.key = key
        }
    }
}
