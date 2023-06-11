//
//  LiveMatchViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import Foundation
import StratzAPI
import Apollo
import SwiftUI

protocol LiveMatchEvent {
    func generateEvent() -> [LiveMatchEventItem]
}

struct LiveMatchEventItem: Identifiable {
    let id = UUID()
    let time: Int
    let isRadiantEvent: Bool
    let icon: String
    let events: [LiveMatchEventDetail]
}

struct LiveMatchEventDetail: Identifiable {
    let id = UUID()
    let type: EventType
    let eventIcon: AnyView?
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

// struct KillEvent: LiveMatchEvent {
//    var id = UUID()
//    var time: Int
//    var kill: [Int]
//    var died: [Int]
// }
//
// struct PurchaseEvent: LiveMatchEvent {
//    var id = UUID()
//    var time: Int
//    var hero: Int
//    var item: Int
// }

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
        let detail = LiveMatchEventDetail(type: .tower, eventIcon: nil, itemName: buildingName, itemIcon: AnyView(icon))
        let iconName = isRadiantEvent ? "icon_radiant" : "icon_dire"
        let event = LiveMatchEventItem(time: time, isRadiantEvent: isRadiantEvent, icon: iconName, events: [detail])
        return [event]
    }
}

class LiveMatchViewModel: ObservableObject {
    var subscription: Cancellable?
    
    private let matchID: Int
    
    // LiveMatchTimerView
    @Published var radiantScore: Int?
    @Published var direScore: Int?
    @Published var time: Int?
    
    @Published var heroes: [LiveMatchHeroPosition] = []
    @Published var buildingStatus: [LiveMatchBuildingEvent] = []
    @Published var events: [LiveMatchEvent] = []
    
    init(matchID: String) {
        guard let matchID = Int(matchID) else {
            self.matchID = 0
            return
        }
        self.matchID = matchID
        fetchHistoryData()
        startSubscription()
    }
    
    private func startSubscription() {
        subscription = Network.shared.apollo.subscribe(subscription: LiveMatchSubscription(matchid: matchID)) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                self?.radiantScore = graphQLResult.data?.matchLive?.radiantScore
                self?.direScore = graphQLResult.data?.matchLive?.direScore
                self?.time = graphQLResult.data?.matchLive?.gameTime
                
                // Players
                if let players = graphQLResult.data?.matchLive?.players {
                    let heroes: [LiveMatchHeroPosition] = players.compactMap { player in
                        guard let player,
                              let heroID = player.heroId,
                              let xPos = player.playbackData?.positionEvents?.first??.x,
                              let yPos = player.playbackData?.positionEvents?.first??.y else {
                            return nil
                        }
                        
                        return LiveMatchHeroPosition(heroID: Int(heroID), xPos: CGFloat(xPos), yPos: CGFloat(yPos))
                    }
                    self?.heroes = heroes
                }
                
                // Towers
                if let buildingEvents = graphQLResult.data?.matchLive?.playbackData?.buildingEvents {
                    let events: [LiveMatchBuildingEvent] = buildingEvents.compactMap { event in
                        guard let event,
                              let buildingID = event.indexId,
                              let xPos = event.positionX,
                              let yPos = event.positionY,
                              let isRadiant = event.isRadiant,
                              let type = event.type else {
                            return nil
                        }
                        return LiveMatchBuildingEvent(indexId: buildingID, time: event.time, type: type, isAlive: event.isAlive, xPos: CGFloat(xPos), yPos: CGFloat(yPos), isRadiant: isRadiant)
                    }
                    Task { [weak self] in
                        await self?.processBuildingEvents(events: events)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchHistoryData() {
        Network.shared.apollo.fetch(query: LiveMatchHistoryQuery(matchid: matchID)) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                
                // Towers
                if let buildingEvents = graphQLResult.data?.live?.match?.playbackData?.buildingEvents {
                    let events: [LiveMatchBuildingEvent] = buildingEvents.compactMap { event in
                        guard let event,
                              let buildingID = event.indexId,
                              let xPos = event.positionX,
                              let yPos = event.positionY,
                              let isRadiant = event.isRadiant,
                              let type = event.type else {
                            return nil
                        }
                        return LiveMatchBuildingEvent(indexId: buildingID, time: event.time, type: type, isAlive: event.isAlive, xPos: CGFloat(xPos), yPos: CGFloat(yPos), isRadiant: isRadiant)
                    }
                    Task { [weak self] in
                        await self?.processBuildingEvents(events: events)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @MainActor
    private func processBuildingEvents(events: [LiveMatchBuildingEvent]) async {
        for event in events {
            if let index = buildingStatus.firstIndex(where: { $0.indexId == event.indexId }) {
                let building = buildingStatus[index]
                if building.isAlive && !event.isAlive {
                    buildingStatus[index] = event
                }
            } else {
                buildingStatus.append(event)
            }
        }
    }
}
