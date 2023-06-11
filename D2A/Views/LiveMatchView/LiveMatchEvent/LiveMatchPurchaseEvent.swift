//
//  LiveMatchPurchaseEvent.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation
import SwiftUI

struct LiveMatchPurchaseEvent: LiveMatchEvent {
    
    var id = UUID()
    var time: Int
    let heroID: Int
    let isRadiant: Bool
    let itemID: Int
    
    private let heroDatabase: HeroDatabase
    
    init(time: Int, heroID: Int, isRadiant: Bool, itemID: Int, heroDatabase: HeroDatabase = HeroDatabase.shared) {
        self.time = time
        self.heroID = heroID
        self.isRadiant = isRadiant
        self.itemID = itemID
        self.heroDatabase = heroDatabase
    }
    
    private var itemIcon: some View {
        ItemView(id: itemID)
            .frame(width: 15, height: 10)
    }
    
    func generateEvent() -> [LiveMatchEventItem] {
        let itemName = heroDatabase.fetchItem(id: itemID)?.dname
        let detail = LiveMatchEventDetail(type: .purchase, itemName: itemName, itemIcon: AnyView(itemIcon))
        return [LiveMatchEventItem(time: time, isRadiantEvent: isRadiant, icon: "\(heroID)_icon", events: [detail])]
    }
}
