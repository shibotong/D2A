//
//  LiveMatchListView.swift
//  D2A
//
//  Created by Shibo Tong on 14/6/2023.
//

import SwiftUI
import StratzAPI

struct LiveMatchListView: View {
    
    @StateObject private var viewModel: LiveMatchListViewModel = .init()
    
    private let gridItems = [GridItem(.adaptive(minimum: 300, maximum: 400))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                matchListView
                if viewModel.loading {
                    loadingView
                }
            }.padding()
            if !viewModel.loading {
                Button {
                    viewModel.loadMore()
                } label: {
                    Text("Load more")
                }
                .buttonStyle(.bordered)
            }
        }
        .refreshable {
            await viewModel.fetchMatchesAsync(existItems: 0)
        }
        .navigationTitle("Live")
    }
    
    private var matchListView: some View {
        ForEach(viewModel.matches) { match in
            NavigationLink(destination: LiveMatchView(viewModel: LiveMatchViewModel(matchID: match.matchId.description))) {
                LiveMatchListRowView(radiantScore: match.radiantScore,
                                     direScore: match.direScore,
                                     radiantHeroes: match.radiantPlayers,
                                     direHeroes: match.direPlayers,
                                     radiantTeam: match.radiantTeam?.description,
                                     direTeam: match.direTeam?.description,
                                     averageRank: match.averageRank,
                                     leagueID: match.leagueId,
                                     leagueName: match.leagueName)
                .padding(5)
            }
        }
    }
    
    private var loadingView: some View {
        ForEach(0...10, id: \.self) { _ in
            LiveMatchListRowEmptyView()
                .padding(5)
        }
    }
}

class LiveMatchListViewModel: ObservableObject {
    @Published var matches: [LiveMatch] = []
    @Published var loading: Bool = false
    
    struct LiveMatch: Identifiable {
        var id: Int {
            return matchId
        }
        let matchId: Int
        var radiantScore: Int
        let direScore: Int
        let leagueId: Int?
        let leagueName: String?
        let averageRank: Int
        let gameTime: Int
        let radiantTeam: Int?
        let direTeam: Int?
        let radiantPlayers: [LiveMatchRowPlayer]
        let direPlayers: [LiveMatchRowPlayer]
    }
    
    init() {
        Task {
            await fetchMatchesAsync(existItems: 0)
        }
    }
    
    func loadMore() {
        let currentItems = matches.count
        Task {
            await fetchMatchesAsync(existItems: currentItems)
        }
    }
    
    func fetchMatchesAsync(existItems: Int) async {
        if existItems == 0 {
            await setMatches([], addMatches: false)
        }
        await setLoading(true)
        await withCheckedContinuation({ checked in
            fetchMatches(existItems: existItems) {
                print("completion")
                checked.resume()
            }
        })
        await setLoading(false)
    }
    
    private func fetchMatches(existItems: Int, completion: (() -> Void)? = nil) {
        let fetchQuery = MatchLiveRequestType(
            gameStates: [
                .case(.teamShowcase),
                .case(.gameInProgress),
                .case(.heroSelection),
                .case(.preGame),
                .case(.strategyTime)
            ],
            skip: GraphQLNullable<Int>(integerLiteral: existItems)
        )
        Network.shared.apollo.fetch(query: LiveMatchListQuery(request: .init(fetchQuery)), cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                guard let matches = graphQLResult.data?.live?.matches else {
                    return
                }
                let newMatches: [LiveMatch] = matches.map { matchData in
                    var radiantPlayers: [LiveMatchRowPlayer] = []
                    var direPlayers: [LiveMatchRowPlayer] = []
                    if let players = matchData?.players {
                        radiantPlayers = players.filter { player in
                            guard let player else {
                                return false
                            }
                            return player.isRadiant ?? false
                        }.map { player in
                            return LiveMatchRowPlayer(heroID: Int(player?.heroId ?? 0), playerName: player?.steamAccount?.proSteamAccount?.name ?? player?.steamAccount?.name, slot: player?.playerSlot ?? 0)
                        }
                        direPlayers = players.filter { player in
                            guard let player else {
                                return false
                            }
                            
                            return !(player.isRadiant ?? true)
                        }.map { player in
                            return LiveMatchRowPlayer(heroID: Int(player?.heroId ?? 0), playerName: player?.steamAccount?.proSteamAccount?.name ?? player?.steamAccount?.name, slot: player?.playerSlot ?? 0)
                        }
                    }
                    
                    let match = LiveMatch(
                        matchId: matchData?.matchId ?? 0,
                        radiantScore: matchData?.radiantScore ?? 0,
                        direScore: matchData?.direScore ?? 0,
                        leagueId: matchData?.leagueId,
                        leagueName: matchData?.league?.displayName,
                        averageRank: matchData?.averageRank ?? 0,
                        gameTime: matchData?.gameTime ?? 0,
                        radiantTeam: matchData?.radiantTeamId,
                        direTeam: matchData?.direTeamId,
                        radiantPlayers: radiantPlayers,
                        direPlayers: direPlayers)
                    return match
                }
                Task { [weak self] in
                    await self?.setMatches(newMatches, addMatches: existItems != 0)
                }
                completion?()
            case .failure(let error):
                print(error.localizedDescription)
                completion?()
            }
        }
    }
    
    @MainActor
    private func setLoading(_ loading: Bool) {
        self.loading = loading
    }
    
    @MainActor
    private func setMatches(_ newMatches: [LiveMatch], addMatches: Bool) {
        if !addMatches {
            matches = []
        }
        for match in newMatches where !self.matches.contains(where: { $0.matchId == match.matchId }) {
            self.matches.append(match)
        }
    }
}

struct LiveMatchListView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchListView()
    }
}
