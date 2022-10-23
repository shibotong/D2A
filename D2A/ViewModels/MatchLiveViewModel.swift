//
//  MatchLiveViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import Foundation

class MatchLiveViewModel: ObservableObject {
    @Published var selection: Int = 0
    @Published var matchLive: Match?
    private var matchID: Int
    
    @Published var towerStatus: [BuildingEvent] = []
    
    @Published var liveEvents: [Event] = []
    
    init(matchID: Int) {
        self.matchID = matchID
    }
    
    func startFetching() {
        fetchHistoryData()
        fetchLiveData()
    }
    
    private func fetchLiveData() {
        Network.shared.apollo.subscribe(subscription: MatchLiveSubscription(id: matchID)) { result in
            switch result {
            case .success(let graphQLResult):
                DispatchQueue.main.async {
                    self.matchLive = self.processMatchLive(data: graphQLResult.data?.matchLive)
                    if let events = graphQLResult.data?.matchLive?.playbackData?.buildingEvents {
                        self.updateBuildingStatus(events: events)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchHistoryData() {
        Network.shared.apollo.fetch(query: MatchLiveHistoryQuery(id: matchID)) { result in
            switch result {
            case .success(let graphQLResult):
                guard let data = graphQLResult.data?.live?.match else {
                    return
                }
                self.updateHistoryEvents(query: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func processMatchLive(data: MatchLiveSubscription.Data.MatchLive?) -> Match? {
        guard let data = data else {
            return nil
        }
        return Match(from: data)
    }
    
    private func updateHistoryEvents(query: MatchLiveHistoryQuery.Data.Live.Match) {
        // setup building status
        let buildingEvents = query.playbackData?.buildingEvents?.compactMap{ $0 }
        self.towerStatus = self.processBuildingStatus(data: buildingEvents)
        
        var events: [Event] = []
        
        // building events
        if let buildingEvents = buildingEvents {
            for event in buildingEvents {
                if let indexId = event.indexId, !event.isAlive {
                    let newEvent = TowerEvent(time: event.time, towerIndex: indexId)
                    if var event = events.first(where: { $0.time == newEvent.time }) {
                        event.events.append(newEvent)
                    } else {
                        events.append(Event(time: newEvent.time, events: [newEvent]))
                    }
                }
            }
        }
        
        var killEvents: [KillEvent] = []
        // kill events
        if let players = query.players {
            for player in players {
                // for each players
                guard let heroID = player?.heroId else {
                    continue
                }
                guard let playerKillEvents = player?.playbackData?.killEvents,
                      let playerDeathEvents = player?.playbackData?.deathEvents else {
                    continue
                }
                
                // kills
                for killEvent in playerKillEvents {
                    // for each kill events for the player
                    guard let killEvent = killEvent else {
                        continue
                    }
                    if let index = killEvents.firstIndex(where: { $0.time == killEvent.time }) {
                        // if events already here add to kill
                        if !killEvents[index].kill.contains(Int(heroID)) {
                            killEvents[index].kill.append(Int(heroID))
                        }
                    } else {
                        // if no events here add a new one
                        killEvents.append(KillEvent(time: killEvent.time, kill: [(Int(heroID))], died: []))
                    }
                }
                
                // deaths
                for deathEvent in playerDeathEvents {
                    guard let deathEvent = deathEvent else {
                        continue
                    }
                    if let index = killEvents.firstIndex(where: { $0.time == deathEvent.time }) {
                        // if events already here add to kill
                        if !killEvents[index].died.contains(Int(heroID)) {
                            killEvents[index].died.append(Int(heroID))
                        }
                    } else {
                        // if no events here add a new one
                        killEvents.append(KillEvent(time: deathEvent.time, kill: [], died: [(Int(heroID))]))
                    }
                }
            }
        }
        
        for killEvent in killEvents {
            if let index = events.firstIndex(where: { $0.time == killEvent.time }) {
                events[index].events.append(killEvent)
            } else {
                events.append(Event(time: killEvent.time, events: [killEvent]))
            }
        }
        
        liveEvents = events.sorted(by: { event0, event1 in
            return event0.time > event1.time
        })
    }
    
    func processBuildingStatus(data: [BuildingEventHistory]?) -> [BuildingEvent] {
        guard let events = data else {
            return []
        }
        var currentStatus: [BuildingEvent] = []
        for event in events {
            if currentStatus.contains(where: { current in
                return current.indexId == event.indexId
            }) {
                // if currenStatus contains current event, remove it and append new
                currentStatus.removeAll { current in
                    return current.indexId == event.indexId
                }
            }
            currentStatus.append(BuildingEvent(from: event))
        }
        return currentStatus
    }
    
    private func updateBuildingStatus(events: [BuildingEventLive?]) {
        for event in events {
            guard let event = event else {
                continue
            }
            if towerStatus.contains(where: { current in
                return current.indexId == event.indexId
            }) {
                // if currenStatus contains current event, remove it and append new
                towerStatus.removeAll { current in
                    return current.indexId == event.indexId
                }
                towerStatus.append(BuildingEvent(from: event))
            }
        }
    }
}
