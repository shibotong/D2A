//
//  OpenDotaFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 9/12/2025.
//

import Testing
@testable import D2A

struct OpenDotaFetcherTests {
    
    private let dataProvider: MockDataProvider
    private let fetcher: OpenDotaFetching
    private let playerID: Int
    
    init() {
        dataProvider = MockDataProvider()
        let network = NetworkProvider(provider: dataProvider)
        fetcher = OpenDotaFetcher(network: network)
        playerID = 123456789
    }
    
    @Test("Test call matches")
    func matches() async throws {
        let testData = try TestDataReader.read(filename: "match", as: [String: Any].self)
        dataProvider.add(data: testData)
        _ = try await fetcher.matches(id: playerID)
        #expect(dataProvider.dataCallCount == 1)
        #expect(dataProvider.urlString == "https://api.opendota.com/api/matches/\(playerID)")
        #expect(dataProvider.query == nil)
    }
    
    @Test("Test call players")
    func players() async throws {
        let testData = try TestDataReader.read(filename: "player", as: [String: Any].self)
        dataProvider.add(data: testData)
        _ = try await fetcher.players(id: playerID)
        #expect(dataProvider.dataCallCount == 1)
        #expect(dataProvider.urlString == "https://api.opendota.com/api/players/\(playerID)")
        #expect(dataProvider.query == nil)
    }
    
    @Test("Test call winloss", arguments: zip([nil, 20], [nil, 10]))
    func winloss(win: Int?, loss: Int?) async throws {
        let testData = ["win": win, "loss": loss]
        dataProvider.add(data: testData)
        let (resultWin, resultLoss) = try await fetcher.playerWinLoss(id: playerID)
        #expect(dataProvider.dataCallCount == 1)
        #expect(dataProvider.urlString == "https://api.opendota.com/api/players/\(playerID)/wl")
        #expect(dataProvider.query == nil)
        #expect(resultWin == win ?? 0)
        #expect(resultLoss == loss ?? 0)
    }
    
    @Test("Test call player matches", arguments: [true, false])
    func playerMatches(ascending: Bool) async throws {
        let testData = try TestDataReader.read(filename: "player_matches", as: [[String: Any]].self)
        dataProvider.add(data: testData)
        _ = try await fetcher.playersMatches(id: playerID, limit: 1, offset: 1, win: true, patch: 1, mode: 2, lobby: 2, region: 1, date: 1, laneRole: 1, heroID: 1, isRadiant: false, includedAccountID: [12345], excludedAccountID: [1234], withHeroID: [1, 2], againstHeroID: [3, 4], significant: false, having: 2, ascending: ascending)
        
        #expect(dataProvider.dataCallCount == 1)
        #expect(dataProvider.urlString == "https://api.opendota.com/api/players/\(playerID)/matches")
        #expect(dataProvider.query?["win"] as? Int == 1)
        #expect(dataProvider.query?["is_radiant"] as? Int == 0)
        #expect(dataProvider.query?["significant"] as? Int == 0)
        #expect(dataProvider.query?["sort"] as? String == (ascending ? "asc" : "desc"))
    }
    
    @Test("Search function")
    func search() async throws {
        let testData = try TestDataReader.read(filename: "search", as: [[String: Any]].self)
        dataProvider.add(data: testData)
        _ = try await fetcher.search(text: "abc")
        #expect(dataProvider.dataCallCount == 1)
        #expect(dataProvider.urlString == "https://api.opendota.com/api/search")
        #expect(dataProvider.query?["q"] as? String == "abc")
    }
}
