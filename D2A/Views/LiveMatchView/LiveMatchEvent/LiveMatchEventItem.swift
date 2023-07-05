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
    
    var eventDescription: LocalizedStringKey {
        switch type {
        case .tower:
            return LocalizedStringKey("destroyed")
        case .kill:
            return LocalizedStringKey("killed a hero")
        case .purchase:
            return LocalizedStringKey("purchased")
        case .died:
            return LocalizedStringKey("has died")
        case .killDied:
            return LocalizedStringKey("killed")
        }
    }
    
    enum EventType {
        case tower, kill, purchase, died, killDied
    }
    
}
