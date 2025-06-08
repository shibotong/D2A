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
    
    var position: CGPoint {
        switch indexId {
        case 0: return .init(x: 87, y: 140)
        case 1: return .init(x: 88, y: 123)
        case 2: return .init(x: 86, y: 108)
        case 3: return .init(x: 117, y: 120)
        case 4: return .init(x: 106, y: 112)
        case 5: return .init(x: 98, y: 103)
        case 6: return .init(x: 158, y: 92)
        case 7: return .init(x: 125, y: 90)
        case 8: return .init(x: 102, y: 91)
        case 9: return .init(x: 91, y: 99)
        case 10: return .init(x: 93, y: 97)
        case 11: return .init(x: 87, y: 106)
        case 12: return .init(x: 84, y: 106)
        case 13: return .init(x: 98, y: 101)
        case 14: return .init(x: 95, y: 103)
        case 15: return .init(x: 100, y: 90)
        case 16: return .init(x: 100, y: 93)
        case 17: return .init(x: 90, y: 96)
        case 18: return .init(x: 98, y: 165)
        case 19: return .init(x: 126, y: 165)
        case 20: return .init(x: 149, y: 164)
        case 21: return .init(x: 130, y: 133)
        case 22: return .init(x: 143, y: 141)
        case 23: return .init(x: 154, y: 151)
        case 24: return .init(x: 166, y: 115)
        case 25: return .init(x: 167, y: 131)
        case 26: return .init(x: 167, y: 147)
        case 27: return .init(x: 158, y: 158)
        case 28: return .init(x: 160, y: 156)
        case 29: return .init(x: 151, y: 162)
        case 30: return .init(x: 151, y: 165)
        case 31: return .init(x: 156, y: 152)
        case 32: return .init(x: 154, y: 154)
        case 33: return .init(x: 168, y: 149)
        case 34: return .init(x: 165, y: 149)
        case 35: return .init(x: 162, y: 159)
        default: return .init(x: 0, y: 0)
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
