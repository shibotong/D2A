//
//  LeaguesHomeViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import Foundation

class LeaguesHomeViewModel: ObservableObject {
        
    let dpcTiers: [LeagueTier] = [.international, .major, .dpcLeague, .dpcQualifier, .dpcLeagueFinals, .dpcLeagueQualifier]
    let otherTiers: [LeagueTier] = [.professional, .amateur]
    
    @Published var leagues: [League] = []
    @Published var upcomingMatches: [LeagueSeries] = []
    
    @Published var liveMatchs: [LeagueSeries] = []
    
    init() {
        startFetchingLeagues(tier: dpcTiers)
        for tier in otherTiers {
            startFetchingLeagues(tier: [tier])
        }
    }
    
    private func startFetchingLeagues(tier: [LeagueTier], skip: Int = 0) {
        let request = LeagueRequestType(tiers: tier, leagueEnded: false, isFutureLeague: false, skip: skip)
        Network.shared.apollo.fetch(query: LeaguesListQuery(leagueRequest: request)) { result in
            switch result {
            case .success(let graphQLResult):
                if let leagues = graphQLResult.data?.leagues?.compactMap({ $0 }) {
                    self.leagues.append(contentsOf: leagues)
                    if tier == self.dpcTiers && leagues.count == 10 && skip <= 30 {
                        self.upcomingMatches.append(contentsOf: self.searchForUpcomingSeries(leagues: leagues))
                        self.startFetchingLeagues(tier: tier, skip: skip + leagues.count)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchForUpcomingSeries(leagues: [League]) -> [LeagueSeries] {
        var upcomingSeries: [LeagueSeries] = []
        for league in leagues {
            guard let nodeGroups = league.nodeGroups else {
                continue
            }
            for nodeGroup in nodeGroups {
                guard let series = nodeGroup?.nodes else {
                    continue
                }
                for matchSeries in series {
                    guard let matchSeries = matchSeries else {
                        continue
                    }
                    
                    if matchSeries.isCompleted == false && matchSeries.scheduledTime != nil {
                        upcomingSeries.append(matchSeries)
                    }
                }
            }
        }
        return upcomingSeries
    }
}
