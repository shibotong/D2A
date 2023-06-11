//
//  LiveMatchEventListView.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import SwiftUI

struct LiveMatchEventListView: View {
    
    var events: [any LiveMatchEvent]
    
    var body: some View {
        List {
            ForEach(events, id: \.id) { event in
                let generateEvents = event.generateEvent()
                ForEach(generateEvents) { generateEvent in
                    LiveMatchEventRowView(event: generateEvent).listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        
    }
}

struct LiveMatchEventListView_Previews: PreviewProvider {
    
    static let buildingEvent = LiveMatchBuildingEvent(indexId: 28, time: 180, type: .case(.tower), isAlive: false, xPos: 160, yPos: 156, isRadiant: false)
    static let killEvent = LiveMatchKillEvent(time: 100, kill: [1], died: [6, 7, 8, 9, 10], players: .preview, heroDatabase: HeroDatabase(heroes: loadSampleHero()!))
    static let purchaseEvent = LiveMatchPurchaseEvent(time: 100, heroID: 1, isRadiant: true, itemID: 1, heroDatabase: HeroDatabase(itemID: loadSampleItemID(), items: loadSampleItem()))
    
    static var previews: some View {
        LiveMatchEventListView(events: [buildingEvent, killEvent, purchaseEvent])
    }
}
