//
//  LiveMatchViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import Foundation
import StratzAPI
import Apollo
import ActivityKit

class LiveMatchViewModel: ObservableObject {
    
    typealias GameState = GraphQLEnum<MatchLiveGameState>
    
    var subscriptions: [Cancellable] = []
    
    private let matchID: Int
    
    // LiveMatchTimerView
    @Published var radiantScore: Int?
    @Published var direScore: Int?
    @Published var time: Int?
    @Published var radiantTeam: String = ""
    @Published var direTeam: String = ""
    
    // LiveMatchMapView
    @Published var heroesPosition: [LiveMatchHeroPosition] = []
    @Published var buildingStatus: [LiveMatchBuildingEvent] = []
    
    // LiveMatchEventView
    @Published var events: [any LiveMatchEvent] = []
    
    // LiveMatchDraftView
    @Published var radiantPick: [LiveMatchPickHero] = []
    @Published var direPick: [LiveMatchPickHero] = []
    @Published var radiantBan: [Int] = []
    @Published var direBan: [Int] = []
    @Published var draftWinRate: Double = 50.0
    @Published var showDraft: Bool = false
    @Published var hasBan: Bool = false
    
    // LiveMatchPlayerView
    @Published var matchPlayers: [PlayerRowViewModel] = []
    
    private var players: LiveMatchPlayers?
    
    private var setDraftState = false
    
    private var radiantLogo: String?
    private var direLogo: String?
    private var leagueId: String?
    private var leagueName: String?
    
    private var lastFetchTime: Int = -100
    
    @Published var status = "Loading..." {
        didSet {
            if !setDraftState {
                setDraftState = true
                let showDraft = status == "Init" ||
                status == "Wait For Players To Load" ||
                status == "Hero Selection" ||
                status == "Strategy Time" ||
                status == "Pre Game"
                self.showDraft = showDraft
            }
        }
    }
    
    init(matchID: String) {
        guard let matchID = Int(matchID) else {
            self.matchID = 0
            return
        }
        self.matchID = matchID
    }
    
    deinit {
        subscriptions = []
    }
    
    func removeSubscription() {
        print("remove subscription")
        subscriptions.forEach { cancellable in
            cancellable.cancel()
        }
        subscriptions = []
    }
    
    func startFetching() {
        print("start subscription")
        fetchHistoryData(lastFetchTime: lastFetchTime)
        startSubscription()
    }
    
//    @MainActor
//    private func executeActivity() {
//        if #available(iOS 16.1, *) {
//            if LiveMatchActivity.shared.activityState() == .active {
//
//            } else {
//                // Here is your code
//                Task {
//                   await LiveMatchActivity.shared.startActivity(
//                        radiantScore: radiantScore ?? 0,
//                        direScore: direScore ?? 0,
//                        time: time ?? 0,
//                        radiantIcon: radiantLogo,
//                        direIcon: direLogo,
//                        league: leagueId,
//                        leagueName: leagueName
//                    )
//                }
//            }
//        }
//    }
    
//    private func endActivity() {
//        if #available(iOS 16.1, *) {
//            Task {
//                await LiveMatchActivity.shared.endActivity()
//            }
//        }
//    }
    
    // MARK: Player
    private struct Player {
        let heroID: Int
        let isRadiant: Bool
        
        let deathEvents: [Int]
        let killEvents: [Int]
    }
    
    private func startSubscription() {
        let subscription = Network.shared.apollo.subscribe(subscription: LiveMatchSubscription(matchid: matchID)) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                self?.radiantScore = graphQLResult.data?.matchLive?.radiantScore
                self?.direScore = graphQLResult.data?.matchLive?.direScore
                self?.time = graphQLResult.data?.matchLive?.gameTime
                if let time = graphQLResult.data?.matchLive?.gameTime {
                    self?.lastFetchTime = time
                }
                if let radiantTeamId = graphQLResult.data?.matchLive?.radiantTeamId, let radiantTeam = self?.radiantTeam, radiantTeam.isEmpty {
                    self?.radiantTeam = radiantTeamId.description
                }
                if let direTeamId = graphQLResult.data?.matchLive?.direTeamId, let direTeam = self?.direTeam, direTeam.isEmpty {
                    self?.direTeam = direTeamId.description
                }
                if let statusString = graphQLResult.data?.matchLive?.gameState?.rawValue {
                    let readableString = statusString.replacingOccurrences(of: "_", with: " ").capitalized
                    self?.status = readableString
                }
                if let radiantLogoURL = graphQLResult.data?.matchLive?.radiantTeam?.logo {
                    self?.radiantLogo = radiantLogoURL
                }
                if let direLogoURL = graphQLResult.data?.matchLive?.direTeam?.logo {
                    self?.direLogo = direLogoURL
                }
                if let leagueId = graphQLResult.data?.matchLive?.league?.id,
                   let leagueName = graphQLResult.data?.matchLive?.league?.displayName {
                    self?.leagueId = leagueId.description
                    self?.leagueName = leagueName
                }
                
                // Draft
                var radiantPick: [LiveMatchPickHero] = []
                var direPick: [LiveMatchPickHero] = []
                var radiantBan: [Int] = []
                var direBan: [Int] = []
                if let draftData = graphQLResult.data?.matchLive?.playbackData?.pickBans,
                   let selfRadiantPick = self?.radiantPick,
                   let selfDirePick = self?.direPick,
                   selfRadiantPick.count < 5,
                   selfDirePick.count < 5 {
                    for data in draftData {
                        guard let data, let isRadiant = data.isRadiant else {
                            continue
                        }
                        if let winRate = data.adjustedWinRate, self?.draftWinRate != winRate {
                            self?.draftWinRate = winRate
                        }
                        if isRadiant && data.isPick {
                            guard let heroID = data.heroId else {
                                continue
                            }
                            radiantPick.append(.init(heroID: Int(heroID), pickLevel: data.letter?.rawValue ?? ""))
                        }
                        if isRadiant && !data.isPick {
                            guard let heroID = data.bannedHeroId else {
                                continue
                            }
                            radiantBan.append(Int(heroID))
                        }
                        if !isRadiant && data.isPick {
                            guard let heroID = data.heroId else {
                                continue
                            }
                            direPick.append(.init(heroID: Int(heroID), pickLevel: data.letter?.rawValue ?? " "))
                        }
                        if !isRadiant && !data.isPick {
                            guard let heroID = data.bannedHeroId else {
                                continue
                            }
                            direBan.append(Int(heroID))
                        }
                    }
                    self?.radiantPick = radiantPick
                    self?.radiantBan = radiantBan
                    self?.direPick = direPick
                    self?.direBan = direBan
                }
                
                // Players
                var killEvents: [LiveMatchKillEvent] = []
                if let liveMatchPlayers = graphQLResult.data?.matchLive?.players {
                    let heroes: [LiveMatchHeroPosition] = liveMatchPlayers.compactMap { player in
                        guard let player,
                              let heroID = player.heroId,
                              let xPos = player.playbackData?.positionEvents?.first??.x,
                              let yPos = player.playbackData?.positionEvents?.first??.y,
                              heroID != 0 else {
                            return nil
                        }
                        return LiveMatchHeroPosition(heroID: Int(heroID), xPos: CGFloat(xPos), yPos: CGFloat(yPos))
                    }
                    self?.heroesPosition = heroes
                    
                    var players: [Player] = []
                    var matchPlayers: [PlayerRowViewModel] = []
                    for player in liveMatchPlayers {
                        guard let player,
                              let heroID = player.heroId,
                              let isRadiant = player.isRadiant else {
                            continue
                        }
                        let deathEvent: [Int] = player.playbackData?.deathEvents?.compactMap { $0?.time } ?? []
                        let killEvent: [Int] = player.playbackData?.killEvents?.compactMap { $0?.time } ?? []
                        
                        let playerRowViewModel = PlayerRowViewModel(player: player)
                        players.append(Player(heroID: Int(heroID), isRadiant: isRadiant, deathEvents: deathEvent, killEvents: killEvent))
                        matchPlayers.append(playerRowViewModel)
                    }
                    self?.matchPlayers = matchPlayers
                    self?.updatePlayersData(players: players)
                    killEvents = self?.processKillEvents(players: players) ?? []
                }
                
                // Towers
                var newBuildingEvents: [LiveMatchBuildingEvent] = []
                if let buildingEvents = graphQLResult.data?.matchLive?.playbackData?.buildingEvents {
                    let events: [LiveMatchBuildingEvent] = buildingEvents.compactMap { event in
                        guard let event,
                              let buildingID = event.indexId,
                              let isRadiant = event.isRadiant,
                              let type = event.type else {
                            return nil
                        }
                        return LiveMatchBuildingEvent(indexId: buildingID, time: event.time, type: type, isAlive: event.isAlive, isRadiant: isRadiant)
                    }
                    newBuildingEvents = self?.processBuildingEvents(events: events) ?? []
                }
                var events: [any LiveMatchEvent] = []
                events.append(contentsOf: newBuildingEvents)
                events.append(contentsOf: killEvents)
                Task { [weak self, events] in
                    await self?.updateEvents(events: events)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        subscriptions.append(subscription)
    }
    
    private func fetchHistoryData(lastFetchTime: Int) {
        let subscription = Network.shared.apollo.fetch(query: LiveMatchHistoryQuery(matchid: matchID)) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                if let gameMode = graphQLResult.data?.live?.match?.gameMode, (gameMode == .captainsMode || gameMode == .captainsDraft) {
                    self?.hasBan = true
                } else {
                    self?.hasBan = false
                }
                
                // Building events
                var buildingEvents: [LiveMatchBuildingEvent] = []
                if let buildingEventsData = graphQLResult.data?.live?.match?.playbackData?.buildingEvents {
                    let events: [LiveMatchBuildingEvent] = buildingEventsData.compactMap { event in
                        guard let event,
                              let buildingID = event.indexId,
                              let isRadiant = event.isRadiant,
                              let type = event.type, event.time > lastFetchTime else {
                            return nil
                        }
                        return LiveMatchBuildingEvent(indexId: buildingID, time: event.time, type: type, isAlive: event.isAlive, isRadiant: isRadiant)
                    }
                    buildingEvents = self?.processBuildingEvents(events: events) ?? []
                }
                
                // Kill event
                var killEvents: [LiveMatchKillEvent] = []
                if let liveMatchPlayers = graphQLResult.data?.live?.match?.players {
                    var players: [Player] = []
                    for player in liveMatchPlayers {
                        guard let player,
                              let heroID = player.heroId,
                              let isRadiant = player.isRadiant else {
                            continue
                        }
                        let deathEvent: [Int] = player.playbackData?.deathEvents?.compactMap { $0?.time }.filter { $0 > lastFetchTime } ?? []
                        let killEvent: [Int] = player.playbackData?.killEvents?.compactMap { $0?.time }.filter { $0 > lastFetchTime} ?? []
                        players.append(Player(heroID: Int(heroID), isRadiant: isRadiant, deathEvents: deathEvent, killEvents: killEvent))
                    }
                    self?.updatePlayersData(players: players)
                    killEvents = self?.processKillEvents(players: players) ?? []
                }
                var events: [any LiveMatchEvent] = []
                events.append(contentsOf: buildingEvents)
                events.append(contentsOf: killEvents)
                Task { [weak self, events] in
                    await self?.updateEvents(events: events)
                }
            case .failure(let error):
                print(error)
            }
        }
        subscriptions.append(subscription)
    }
    
    private func processBuildingEvents(events: [LiveMatchBuildingEvent]) -> [LiveMatchBuildingEvent] {
        var newEvent: [LiveMatchBuildingEvent] = []
        for event in events {
            Task {
                await updateBuilding(event: event)
            }
            if !event.isAlive {
                newEvent.append(event)
            }
        }
        return newEvent
    }
    
    @MainActor
    private func updateBuilding(event: LiveMatchBuildingEvent) async {
        if let index = buildingStatus.firstIndex(where: { $0.indexId == event.indexId }) {
            let building = buildingStatus[index]
            if building.isAlive && !event.isAlive {
                buildingStatus[index] = event
            }
        } else {
            buildingStatus.append(event)
        }
    }
    
    private func updatePlayersData(players: [Player]) {
        guard self.players == nil, players.count == 10 else {
            return
        }
        
        // update players
        // process radiant players
        let radiantPlayerIDs: [Int] = players.filter { $0.isRadiant }.map { $0.heroID }
        
        // process dire players
        let direPlayerIDs: [Int] = players.filter { !$0.isRadiant }.map { $0.heroID }
        
        if radiantPlayerIDs.count == 5 && direPlayerIDs.count == 5 {
            self.players = LiveMatchPlayers(radiant: radiantPlayerIDs, dire: direPlayerIDs)
        }
    }
    
    private func processKillEvents(players: [Player]) -> [LiveMatchKillEvent] {
        guard let matchPlayers = self.players else {
            return []
        }
        var killEvents: [LiveMatchKillEvent] = []
        for player in players {
            let heroID = player.heroID
            let playerKillEvents = player.killEvents
            let playerDeathEvents = player.deathEvents
            
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
                    killEvents.append(LiveMatchKillEvent(time: killEvent, kill: [heroID], died: [], players: matchPlayers))
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
                    killEvents.append(LiveMatchKillEvent(time: deathEvent, kill: [], died: [heroID], players: matchPlayers))
                }
            }
        }
        return killEvents
    }
    
    @MainActor
    private func updateEvents(events: [any LiveMatchEvent]) {
        if self.events.isEmpty {
            self.events = events.sorted(by: { $0.time > $1.time })
        } else {
            let newEvents = events.sorted(by: { $0.time > $1.time })
            self.events.insert(contentsOf: newEvents, at: 0)
        }
    }
}
