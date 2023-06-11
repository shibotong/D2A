//
//  LiveMatchViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import Foundation
import StratzAPI
import Apollo

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
