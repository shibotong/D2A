//
//  MatchLiveViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import Foundation

class MatchLiveViewModel: ObservableObject {
    private var matchID: Int
    
    @Published var selection: Int = 0
    @Published var matchLive: Match?
    @Published var towerStatus: [BuildingEvent] = []
    @Published var liveEvents: [Event] = []
    @Published var drafts: [BanPick] = []
    
    init(matchID: Int) {
        self.matchID = matchID
    }
    
    init() {
        matchLive = Match.liveMatch
        matchID = 0
    }
    
    func startFetching() {
        fetchHistoryData()
        fetchLiveData()
    }
    
    private func fetchLiveData() {
        Network.shared.apollo.subscribe(subscription: MatchLiveSubscription(id: matchID)) { result in
            switch result {
            case .success(let graphQLResult):
                guard let data = graphQLResult.data?.matchLive else {
                    return
                }
                self.matchLive = self.processLiveEvents(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchHistoryData() {
        Network.shared.apollo.fetch(query: MatchLiveHistoryQuery(id: matchID)) { result in
            switch result {
            case .success(let graphQLResult):
                guard let data = graphQLResult.data?.live?.match else {
                    return
                }
                self.processHistoryEvents(query: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func processLiveEvents(data: MatchLiveSubscription.Data.MatchLive) -> Match? {
        let match = Match(from: data)
        if let draftData = data.playbackData?.pickBans?.compactMap({ $0 }).map({ BanPick(from: $0) }) {
            self.drafts = draftData
        }
        // tower events performing
        var buildingEvents: [BuildingEvent] = []
        if let buildingEventsData = data.playbackData?.buildingEvents, !buildingEventsData.isEmpty {
            let events = buildingEventsData.compactMap({ $0 }).map { BuildingEvent(from: $0) }
            buildingEvents = processBuildingEvents(events: events)
        }
        
        // kill events performing
        var killEvents: [KillEvent] = []
        // kill events
        if let players = data.players {
            killEvents = processKillEvents(players: players.compactMap({ $0 }).map{ Player(from: $0) })
        }
        
        let combinedEvents = combineEvents(buildingEvents: buildingEvents, killEvents: killEvents)
        
        self.liveEvents.insert(contentsOf: combinedEvents.sorted(by: { $0.time > $1.time }), at: 0)
        
        return match
    }
    
    private func processHistoryEvents(query: MatchLiveHistoryQuery.Data.Live.Match) {
        if let draftData = query.playbackData?.pickBans?.compactMap({ $0 }).map({ BanPick(from: $0) }) {
            self.drafts = draftData
        }
        // setup building status
        var buildingEvents: [BuildingEvent] = []
        if let buildingEventsData = query.playbackData?.buildingEvents?.compactMap({ $0 }).map({ BuildingEvent(from: $0) }) {
            buildingEvents = self.processBuildingEvents(events: buildingEventsData)
        }
        
        var killEvents: [KillEvent] = []
        // kill events
        if let players = query.players {
            killEvents = self.processKillEvents(players: players.compactMap({ $0 }).map{ Player(from: $0) })
        }
        
        liveEvents = combineEvents(buildingEvents: buildingEvents, killEvents: killEvents)
    }
    
    private func processDraftData(drafts: [BanPick]) {
        
    }
    
    private func combineEvents(buildingEvents: [BuildingEvent], killEvents: [KillEvent]) -> [Event] {
        var events: [Event] = []
        for event in killEvents {
            if let index = events.firstIndex(where: { $0.time == event.time }) {
                events[index].events.append(event)
            } else {
                events.append(Event(time: event.time, events: [event]))
            }
        }
        
        for event in buildingEvents {
            if let index = events.firstIndex(where: { $0.time == event.time }) {
                events[index].events.append(event)
            } else {
                events.append(Event(time: event.time, events: [event]))
            }
        }
        
        return events.sorted(by: { event0, event1 in
            return event0.time > event1.time
        })
    }
    
    private func processBuildingEvents(events: [BuildingEvent]) -> [BuildingEvent] {
        var newEvents: [BuildingEvent] = []
        for event in events {
            if let index = towerStatus.firstIndex(where: { $0.indexId == event.indexId }) {
                let building = towerStatus[index]
                if building.isAlive && !event.isAlive {
                    towerStatus[index] = event
                    newEvents.append(event)
                }
            } else {
                towerStatus.append(event)
            }
        }
        return newEvents
    }
    
    private func processKillEvents(players: [Player]) -> [KillEvent] {
        
        var killEvents: [KillEvent] = []
        
        for player in players {
            // for each players
            let heroID = player.heroID
            guard let playerKillEvents = player.killEvents,
                  let playerDeathEvents = player.deathEvents else {
                continue
            }
            
            // kills
            for killEvent in playerKillEvents {
                // for each kill events for the player
                if let index = killEvents.firstIndex(where: { $0.time == killEvent }) {
                    // if events already here add to kill
                    if !killEvents[index].kill.contains(Int(heroID)) {
                        killEvents[index].kill.append(Int(heroID))
                    }
                } else {
                    // if no events here add a new one
                    killEvents.append(KillEvent(time: killEvent, kill: [(Int(heroID))], died: []))
                }
            }
            
            // deaths
            for deathEvent in playerDeathEvents {
                if let index = killEvents.firstIndex(where: { $0.time == deathEvent }) {
                    // if events already here add to kill
                    if !killEvents[index].died.contains(Int(heroID)) {
                        killEvents[index].died.append(Int(heroID))
                    }
                } else {
                    // if no events here add a new one
                    killEvents.append(KillEvent(time: deathEvent, kill: [], died: [(Int(heroID))]))
                }
            }
        }
        
        return killEvents
    }
}
