//
//  LiveMatchEventItem.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation
import SwiftUI

protocol LiveMatchEvent: Identifiable {
    var id: UUID { get set }
    var time: Int { get set }
    func generateEvent() -> [LiveMatchEventItem]}

// MARK: LiveMatchEventItem
struct LiveMatchEventItem: Identifiable {
    let id = UUID()
    let time: Int
    let isRadiantEvent: Bool
    let icon: String
    let events: [LiveMatchEventDetail]
}

// MARK: LiveMatchEventDetail
struct LiveMatchEventDetail: Identifiable {
    let id = UUID()
    let type: EventType
    let itemName: String?
    let itemIcon: AnyView?
    
    var eventDescription: String {
        switch type {
        case .tower:
            return "destroyed"
        case .kill:
            return "killed a hero"
        case .purchase:
            return "purchased"
        case .died:
            return "has died"
        case .killDied:
            return "killed"
        }
    }
    
    enum EventType {
        case tower, kill, purchase, died, killDied
    }
    
}
