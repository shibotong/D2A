//
//  LiveMatchBuildingEvent.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation
import StratzAPI
import SwiftUI

struct LiveMatchBuildingEvent: LiveMatchEvent {
    typealias Building = GraphQLEnum<BuildingType>
    
    var id = UUID()
    
    let indexId: Int
    
    var time: Int
    let type: Building
    let isAlive: Bool
    
    var xPos: CGFloat {
        switch indexId {
        case 0: return 79
        case 1: return 80
        case 2: return 77
        case 3: return 117
        case 4: return 103
        case 5: return 92
        case 6: return 165
        case 7: return 125
        case 8: return 97
        case 9: return 83
        case 10: return 87
        case 11: return 79
        case 12: return 75
        case 13: return 91
        case 14: return 89
        case 15: return 94
        case 16: return 94
        case 17: return 83
        case 18: return 91
        case 19: return 126
        case 20: return 154
        case 21: return 132
        case 22: return 145
        case 23: return 160
        case 24: return 175
        case 25: return 177
        case 26: return 175
        case 27: return 165
        case 28: return 169
        case 29: return 157
        case 30: return 157
        case 31: return 163
        case 32: return 161
        case 33: return 177
        case 34: return 173
        case 35: return 169
        default: return 0
        }
    }
    
    var yPos: CGFloat {
        switch indexId {
        case 0: return 140
        case 1: return 120
        case 2: return 101
        case 3: return 117
        case 4: return 104
        case 5: return 95
        case 6: return 81
        case 7: return 80
        case 8: return 81
        case 9: return 90
        case 10: return 86
        case 11: return 98
        case 12: return 98
        case 13: return 92
        case 14: return 94
        case 15: return 79
        case 16: return 83
        case 17: return 86
        case 18: return 172
        case 19: return 173
        case 20: return 170
        case 21: return 133
        case 22: return 144
        case 23: return 156
        case 24: return 110
        case 25: return 131
        case 26: return 149
        case 27: return 165
        case 28: return 161
        case 29: return 168
        case 30: return 172
        case 31: return 157
        case 32: return 159
        case 33: return 152
        case 34: return 152
        case 35: return 165
        default: return 0
        }
    }
    
    let isRadiant: Bool
    
    var isRadiantEvent: Bool {
        return !isRadiant
    }
    
    private var buildingName: String {
        return "\(lane)\(buildingPosition)\(buildingType)"
    }
    
    private var teamString: String {
        return isRadiant ? "Radiant " : "Dire "
    }
    
    private var buildingType: String {
        switch type {
        case .tower:
            return "Tower"
        case .barracks:
            return "Barracks"
        case .fort:
            return "Fountain"
        default:
            return ""
        }
    }
    
    private var lane: String {
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
    
    private var buildingPosition: String {
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
    
    private var icon: some View {
        ZStack {
            if type == .tower {
                Circle()
            } else {
                Rectangle()
            }
        }
        .frame(width: 15, height: 15)
        .foregroundColor(isRadiant ? Color.green : Color.red)
    }
    
    func generateEvent() -> [LiveMatchEventItem] {
        guard !isAlive else {
            return []
        }
        let detail = LiveMatchEventDetail(type: .tower, itemName: buildingName, itemIcon: AnyView(icon))
        let iconName = isRadiantEvent ? "icon_radiant" : "icon_dire"
        let event = LiveMatchEventItem(time: time, isRadiantEvent: isRadiantEvent, icon: iconName, events: [detail])
        return [event]
    }
}
