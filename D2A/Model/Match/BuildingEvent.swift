//
//  BuildingEvent.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation

struct BuildingEvent {
    var indexId: Int
    var isAlive: Bool
    var isRadiant: Bool
    var npcId: Int
    var positionX: Int?
    var positionY: Int?
    var time: Int
    var type: BuildingType
    
    init(from event: BuildingEventLive) {
        indexId = event.indexId ?? 0
        isAlive = event.isAlive
        isRadiant = event.isRadiant ?? false
        npcId = event.npcId ?? 0
        positionX = event.positionX
        positionY = event.positionY
        time = event.time
        type = event.type ?? .tower
    }
    
    init(from event: BuildingEventHistory) {
        indexId = event.indexId ?? 0
        isAlive = event.isAlive
        isRadiant = event.isRadiant ?? false
        npcId = event.npcId ?? 0
        positionX = event.positionX
        positionY = event.positionY
        time = event.time
        type = event.type ?? .tower
    }
}
