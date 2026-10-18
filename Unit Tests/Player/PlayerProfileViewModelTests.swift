//
//  PlayerProfileViewModelTests.swift
//  D2A
//
//  Created by Shibo Tong on 13/10/2026.
//

import Testing
import CoreData
@testable import D2A

@Suite(.serialized)
@MainActor
struct PlayerProfileViewModelTests {
    
    let contextProvider: MockCoreDataContextProvider
    let fetcher: MockGameDataFetcher
    let userID: String
    private let mainContext: NSManagedObjectContext
    
    init() {
        userID = UUID().uuidString
        contextProvider = MockCoreDataContextProvider()
        fetcher = MockGameDataFetcher()
        mainContext = PersistenceProvider.shared.mainContext
        contextProvider.mainContextResult = mainContext
        contextProvider.backgroundContextResult = mainContext
    }
    
    @Test
    func `no user profile on init when no saved user profile`() {
        let viewModel = createViewModel()
        #expect(contextProvider.mainContextCount == 2)
        #expect(viewModel.profile == nil)
        #expect(viewModel.matches == [])
    }
    
    @Test
    func `fetch existing user and existing matches on init`() async throws {
        let user = UserProfile.make(context: mainContext)
            .with(path: \.id, value: userID)
        let olderMatch = makeMatch(id: "1", startTime: Date(timeIntervalSince1970: 100))
        let newerMatch = makeMatch(id: "2", startTime: Date(timeIntervalSince1970: 200))
        try mainContext.save()

        let viewModel = createViewModel()

        let fetchedUser = try #require(viewModel.profile)
        #expect(fetchedUser.userId == user.userId)
        #expect(viewModel.matches.map(\.id) == [newerMatch.id, olderMatch.id])
    }

    @Test
    func `refresh user creates and saves profile`() async throws {
        fetcher.fetchUserResult = UserProfileDTOStub(id: 42, personaname: "Yatoro")
        let viewModel = createViewModel()

        await viewModel.refreshUser()

        let profile = try #require(viewModel.profile)
        #expect(fetcher.fetchUserCount == 1)
        #expect(profile.id == "42")
        #expect(profile.personaname == "Yatoro")
        #expect(!mainContext.hasChanges)
        #expect(viewModel.error == nil)
    }

    @Test
    func `refresh user reports fetch failure`() async {
        fetcher.fetchUserClosure = { _ in throw TestError.expected }
        let viewModel = createViewModel()

        await viewModel.refreshUser()

        #expect(fetcher.fetchUserCount == 1)
        #expect(viewModel.profile == nil)
        guard case .fetchUserProfileError = viewModel.error else {
            Issue.record("Expected a user profile error")
            return
        }
    }

    @Test
    func `load matches inserts small response and passes latest match date`() async throws {
        let latestDate = Date(timeIntervalSince1970: 200)
        let existingMatch = makeMatch(id: "1", startTime: latestDate)
        try mainContext.save()
        let dto = RecentMatchDTOStub(matchId: 2, startTime: Date(timeIntervalSince1970: 300))
        var requestedLastGameDate: Date?
        fetcher.fetchPlayerMatchesClosure = { requestedUserID, lastGameDate in
            #expect(requestedUserID == userID)
            requestedLastGameDate = lastGameDate
            return [dto]
        }
        let viewModel = createViewModel(insertThreshold: 1)

        await viewModel.loadMatches()

        #expect(fetcher.fetchPlayerMatchesCount == 1)
        #expect(requestedLastGameDate == latestDate)
        #expect(viewModel.matches.map(\.id) == ["2", existingMatch.id])
        #expect(viewModel.matchLoading == false)
        #expect(viewModel.error == nil)
    }

    @Test
    func `load matches batch inserts large response and reloads matches`() async {
        let olderDTO = RecentMatchDTOStub(matchId: 1, startTime: Date(timeIntervalSince1970: 100))
        let newerDTO = RecentMatchDTOStub(matchId: 2, startTime: Date(timeIntervalSince1970: 200))
        fetcher.fetchPlayerMatchesResult = [olderDTO, newerDTO]
        let viewModel = createViewModel(insertThreshold: 1)

        await viewModel.loadMatches()

        #expect(contextProvider.backgroundContextCount == 1)
        #expect(viewModel.matches.map(\.id) == ["2", "1"])
        #expect(viewModel.matchLoading == false)
        #expect(viewModel.error == nil)
    }

    @Test
    func `load matches reports fetch failure and stops loading`() async {
        fetcher.fetchPlayerMatchesClosure = { _, _ in throw TestError.expected }
        let viewModel = createViewModel()

        await viewModel.loadMatches()

        #expect(fetcher.fetchPlayerMatchesCount == 1)
        #expect(viewModel.matchLoading == false)
        guard case .fetchUserMatchesError = viewModel.error else {
            Issue.record("Expected a user matches error")
            return
        }
    }
    
    private func createViewModel(insertThreshold: Int = 20) -> PlayerProfileView.ViewModel {
        .init(
            userID: userID,
            fetcher: fetcher,
            contextProvider: contextProvider,
            insertThreshold: insertThreshold
        )
    }

    private func makeMatch(id: String, startTime: Date) -> RecentMatch {
        let match = RecentMatch(context: mainContext)
        match.id = id
        match.playerId = userID
        match.startTime = startTime
        return match
    }
    
}

private enum TestError: Error {
    case expected
}

private struct UserProfileDTOStub: UserProfileDTO {
    let id: Int
    let avatarfull = "https://example.com/avatar.png"
    let lastLogin: Date? = nil
    let countryCode: String? = nil
    let personaname: String
    let isPlus = false
    let profileurl: String? = nil
    let rank: Int? = nil
    let leaderboard: Int? = nil
    let name: String? = nil
}

private struct RecentMatchDTOStub: RecentMatchDTO {
    let matchId: Int
    let playerSlot = 0
    let radiantWin: Bool? = true
    let duration = 1_800
    let gameMode = 1
    let lobbyType = 0
    let heroId = 1
    let startTime: Date
    let version: Int? = nil
    let kills = 1
    let deaths = 2
    let assists = 3
    let averageRank: Int? = nil
    let leaverStatus: Int? = nil
    let partySize: Int? = nil
    let heroVariant: Int? = nil
}
