//
//  ODMatch+Chat.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

extension ODMatch {
    struct Chat: Decodable {
        let time: Int
        let unit: String
        let key: String
        let slot: Int
        let playerSlot: Int
    }
}
