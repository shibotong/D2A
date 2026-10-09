//
//  PlayerProfileViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 9/10/2026.
//

import Foundation
import CoreData

enum ProfileError: Error {
    case userFetchError
    case userSaveError
}

extension PlayerProfileView {
    class ViewModel: ObservableObject {
        
        @Published var profile: UserProfile?
        @Published var errorAlert = false
        @Published var matchLoading = false
        
        private let fetcher: GameDataFetcher
        private let userID: String
        private let context: NSManagedObjectContext
        private let logger: D2ALogger
        
//        convenience init(userID: String,
//                         playerFetcher: PlayerProfileFetching,
//                         context: NSManagedObjectContext) {
////            self.userID = userID
////            self.playerFetcher = playerFetcher
////            self.context = context
//        }
        
        init(profile: UserProfile?,
             userID: String,
             fetcher: GameDataFetcher,
             context: NSManagedObjectContext,
             logger: D2ALogger = .shared) {
            self.profile = profile
            self.userID = userID
            self.fetcher = fetcher
            self.context = context
            self.logger = logger
        }
        
        func refreshUser() async {
            do {
                let userProfileDTO = try await fetcher.fetchUser(userID: userID)
                if profile == nil {
                    profile = UserProfile(context: context)
                }
                profile?.map(userProfileDTO)
                try context.save()
            } catch {
                logger.error("Failed to refresh user profile \(userID). \(error)", category: .user)
                errorAlert = true
            }
        }
        
        func loadMatches() async {
            guard let userID = profile.first?.id else {
                return
            }
            await matchLoading = true
            defer { matchLoading = false }
            if let firstMatch = matches.first {
                await OpenDotaController.shared.loadRecentMatch(
                    userid: userID,
                    days: firstMatch.startTime?.timeIntervalSinceNow
                )
            } else {
                await OpenDotaController.shared.loadRecentMatch(userid: userID)
            }
        }
    }
}
