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
        
        func refreshData() async {
            do {
                let mainContext = contextProvider.mainContext
                profile = try UserProfile.fetch(userID: userID, viewContext: mainContext)
                loadUserMatches()
                await refreshUser()
                await loadMatches()
            } catch {
                logger.error("An error occured when fetching user profile \(error)", category: .coreData)
            }
        }
        
        private func refreshUser() async {
            let shouldRefreshProfile: Bool
            if let profile {
                shouldRefreshProfile = profile.shouldUpdate
                logger.debug("User ID \(userID) last fetch time \(shouldRefreshProfile). Needs to refresh: \(shouldRefreshProfile)", category: .user)
            } else {
                logger.debug("User ID \(userID) doesn't exist. Should fetch user profile", category: .user)
                shouldRefreshProfile = true
            }
            
            guard shouldRefreshProfile else {
                return
            }
            
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
            guard !matchLoading else {
                return
            }
            
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
        
        private func loadUserMatches() {
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
