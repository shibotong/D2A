//
//  ODMatch+Player+PurchaseLog.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch.Player {
    struct PurchaseLog: Decodable {
        let time: Int
        let key: String
        let charges: Int
        
        init(time: Int, key: String, charges: Int) {
            self.time = time
            self.key = key
            self.charges = charges
        }
        
        enum CodingKeys: CodingKey {
            case time
            case key
            case charges
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.PurchaseLog.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.PurchaseLog.CodingKeys.self)
            self.time = try container.decode(Int.self, forKey: ODMatch.Player.PurchaseLog.CodingKeys.time)
            self.key = try container.decode(String.self, forKey: ODMatch.Player.PurchaseLog.CodingKeys.key)
            self.charges = try container.decode(Int.self, forKey: ODMatch.Player.PurchaseLog.CodingKeys.charges)
        }
    }
}
