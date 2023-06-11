//
//  LiveMatchPurchaseEvent.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation

struct PurchaseEvent: LiveMatchEvent {
    
    let id = UUID()
    let time: Int
    let heroID: Int
    let isRadiant: Bool
    let itemID: Int
    
    let players: LiveMatchPlayers
    
    func generateEvent() -> [LiveMatchEventItem] {
        let detail = LiveMatchEventDetail(type: .purchase, itemName: <#T##String?#>, itemIcon: <#T##AnyView?#>)
    }
}
