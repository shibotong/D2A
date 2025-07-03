//
//  GameDataController.swift
//  D2A
//
//  Created by Shibo Tong on 3/7/2025.
//

import Foundation
import CoreData

class GameDataController: ObservableObject {
    
    static let shared = GameDataController()
    
    private let context: NSManagedObjectContext
    private let openDotaProvider: OpenDotaProviding
    
    init(context: NSManagedObjectContext = PersistanceProvider.shared.container.viewContext,
         openDotaProvider: OpenDotaProviding = OpenDotaProvider.shared) {
        self.context = context
        self.openDotaProvider = openDotaProvider
    }
    
    func loadRecentMatches(for userID: String) async {
        let latestMatch = RecentMatch.fetch(userID: userID, count: 1, viewContext: context).first
        var days: Double?
        // here should be timeIntervalSinceNow
        if let lastMatchStartTime = latestMatch?.startTime?.timeIntervalSinceNow {
            let oneDay: Double = 60 * 60 * 24
            
            // Decrease 1 sec to avoid adding repeated match
            days = -(lastMatchStartTime + 1) / oneDay
        }
        let newMatchesData = await openDotaProvider.loadRecentMatch(userid: userID, days: days)
        try? await RecentMatch.create(newMatchesData, viewContext: context)
    }
}
