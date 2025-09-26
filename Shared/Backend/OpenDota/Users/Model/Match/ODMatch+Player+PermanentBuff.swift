//
//  ODMatch+Player+PermanentBuff.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch.Player {
    struct PermanentBuff: Decodable {
        let buffID: Int
        let stack: Int
        
        enum CodingKeys: String, CodingKey {
            case buffID = "permanent_buff"
            case stack = "stack_count"
        }
        
        init(buffID: Int, stack: Int) {
            self.buffID = buffID
            self.stack = stack
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.PermanentBuff.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.PermanentBuff.CodingKeys.self)
            self.buffID = try container.decode(Int.self, forKey: ODMatch.Player.PermanentBuff.CodingKeys.buffID)
            self.stack = try container.decode(Int.self, forKey: ODMatch.Player.PermanentBuff.CodingKeys.stack)
        }
    }
}
