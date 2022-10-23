//
//  MatchLiveViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import Foundation

class MatchLiveViewModel: ObservableObject {
    @Published var matchLive: Match?
    private var matchID: Int
    
    @Published var towerStatus: [BuildingEvent] = []
    
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
                        print(events)
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
                let buildingEvents = graphQLResult.data?.live?.match?.playbackData?.buildingEvents?.compactMap{ $0 }
                self.towerStatus = self.processBuildingStatus(data: buildingEvents)
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
