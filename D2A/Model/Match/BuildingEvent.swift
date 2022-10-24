//
//  BuildingEvent.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation

struct BuildingEvent: LiveEvent {
    var id = UUID()
    var indexId: Int
    var isAlive: Bool
    var isRadiant: Bool
    var npcId: Int
    var positionX: Int?
    var positionY: Int?
    var time: Int
    var type: BuildingType
    
    var towerString: String {
        return "\(teamString)\(lane)\(buildingPosition)\(towerType)"
    }
    
    var teamString: String {
        return isRadiant ? "Radiant " : "Dire "
    }
    
    var towerType: String {
        switch indexId {
        case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28:
            return "Tower"
        case 11, 12, 13, 14, 15, 16, 29, 30, 31, 32, 33, 34:
            return "Barracks"
        case 17, 35:
            return "Fountain"
        default:
            return ""
        }
    }
    
    var lane: String {
        switch indexId {
        case 0, 1, 2, 11, 12, 18, 19, 20, 29, 30:
            return "Top "
        case 3, 4, 5, 13, 14, 21, 22, 23, 31, 32:
            return "Mid "
        case 6, 7, 8, 15, 16, 24, 25, 26, 33, 34:
            return "Btm "
        default:
            return ""
        }
    }
    
    var buildingPosition: String {
        switch indexId {
        case 0, 3, 6, 18, 21, 24:
            return "T1 "
        case 1, 4, 7, 19, 22, 25:
            return "T2 "
        case 2, 5, 8, 20, 23, 26:
            return "T3 "
        case 11, 13, 15, 29, 31, 33:
            return "Melee "
        case 12, 14, 16, 30, 32, 34:
            return "Ranged "
        case 9, 10, 27, 28:
            return "T4 "
        default:
            return ""
        }
    }
    
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
