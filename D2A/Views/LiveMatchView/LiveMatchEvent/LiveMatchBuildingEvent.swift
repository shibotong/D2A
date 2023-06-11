//
//  LiveMatchBuildingEvent.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation
import StratzAPI
import SwiftUI

struct LiveMatchBuildingEvent: Identifiable, LiveMatchEvent {
    typealias Building = GraphQLEnum<BuildingType>
    
    var id = UUID()
    
    let indexId: Int
    
    let time: Int
    let type: Building
    let isAlive: Bool
    let xPos: CGFloat
    let yPos: CGFloat
    let isRadiant: Bool
    
    var isRadiantEvent: Bool {
        return !isRadiant
    }
    
    private var buildingName: String {
        return "\(teamString)\(lane)\(buildingPosition)\(buildingType)"
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
