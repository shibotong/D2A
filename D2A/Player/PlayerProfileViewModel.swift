//
//  PlayerProfileViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 9/10/2026.
//

import Foundation
import CoreData
import OpenDota

enum PlayerProfileViewError: LocalizedError {
    case fetchUserProfileError
    case fetchUserMatchesError
    
    var errorDescription: String {
        switch self {
        case .fetchUserProfileError:
            return NSLocalizedString("Failed to fetch user.", comment: "Failed to fetch user profile")
        case .fetchUserMatchesError:
            return NSLocalizedString("Failed to fetch matches.", comment: "Failed to fetch user matches")
        }
    }

    /// A localized message describing the reason for the failure.
    var failureReason: String? {
        switch self {
        case .fetchUserProfileError:
            return NSLocalizedString("Failed to fetch user.", comment: "Failed to fetch user profile")
        case .fetchUserMatchesError:
            return NSLocalizedString("Failed to fetch matches.", comment: "Failed to fetch user matches")
        }
    }

    /// A localized message describing how one might recover from the failure.
    var recoverySuggestion: String? {
        NSLocalizedString("Please submit an issue in Github", comment: "")
    }
}

extension PlayerProfileView {
    class ViewModel: ObservableObject {
        
        @Published var profile: UserProfile?
        @Published var matches: [RecentMatch]

        @Published var error: PlayerProfileViewError?
        @Published var matchLoading = false
        
        private let fetcher: GameDataFetcher
        private let userID: String
        private let contextProvider: CoreDataContextProviding
        private let logger: D2ALogger
        private let insertThreshold: Int
        private let refreshHandler: UserMatchRefreshHandler
        
        init(profile: UserProfile? = nil,
             userID: String,
             matches: [RecentMatch] = [],
             fetcher: GameDataFetcher = OpenDotaFetcher.shared,
             contextProvider: CoreDataContextProviding = PersistenceProvider.shared,
             insertThreshold: Int = 20,
             refreshHandler: UserMatchRefreshHandler = .shared,
             logger: D2ALogger = .shared) {
            self.profile = profile
            self.userID = userID
            self.matches = matches
            self.fetcher = fetcher
            self.contextProvider = contextProvider
            self.insertThreshold = insertThreshold
            self.refreshHandler = refreshHandler
            self.logger = logger
        }
        
        func refreshUser() async {
            do {
                let userProfileDTO = try await fetcher.fetchUser(userID: userID)
                let context = contextProvider.mainContext
                if profile == nil {
                    profile = UserProfile(context: context)
                }
                profile?.map(userProfileDTO)
                try context.save()
            } catch {
                logger.error("Failed to refresh user profile \(userID). \(error)", category: .user)
                self.error = PlayerProfileViewError.fetchUserProfileError
            }
        }
        
        func loadMatches() async {
            guard await refreshHandler.canRefresh(userid: userID) else {
                return
            }
            matchLoading = true
            defer { matchLoading = false }
            do {
                let matches = try await fetcher.fetchPlayerMatches(
                    userID: userID,
                    lastGameDate: matches.first?.startTime
                )
                if matches.count <= insertThreshold {
                    let context = contextProvider.mainContext
                    let newMatches = try RecentMatch.insertMatches(matches, to: userID, context: context)
                    self.matches.insert(contentsOf: newMatches, at: 0)
                    return
                } else {
                    try RecentMatch.batchInsertMatches(matches, to: userID, mainContext: contextProvider.mainContext, backgroundContext: contextProvider.backgroundContext(name: "RecentMatch"))
                    loadUserMatches()
                }
            } catch {
                logger.error("Failed to fetch latest matches \(error)", category: .coreData)
                self.error = PlayerProfileViewError.fetchUserMatchesError
            }
        }
        
        func loadUser() {
            guard profile == nil else {
                logger.debug("Profile already exist for \(userID)", category: .user)
                return
            }
            let context = contextProvider.mainContext
            let request = UserProfile.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", userID)
            request.fetchLimit = 1
            do {
                guard let user = try context.fetch(request).first else {
                    logger.debug("Profile doesn't exist for \(userID)", category: .user)
                    return
                }
                self.profile = user
            } catch {
                logger.error("Failed to fetch user profile \(userID). \(error)", category: .coreData)
                return
            }
        }
        
        func loadUserMatches() {
            let context = contextProvider.mainContext
            let request = RecentMatch.fetchRequest()
            request.fetchLimit = 10
            request.fetchBatchSize = 1
            request.predicate = NSPredicate(format: "playerId = %@", userID)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)]
            do {
                matches = try context.fetch(request)
            } catch {
                logger.error("Error fetching recent matches for user \(userID). \(error)", category: .coreData)
            }
        }
    }
}
