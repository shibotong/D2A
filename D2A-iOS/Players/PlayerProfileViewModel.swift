//
//  PlayerProfileViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 12/8/2025.
//

import Foundation
import CoreData

class PlayerProfileViewModel: ObservableObject {
    
    @Published var user: UserProfile?
    @Published var matches: [RecentMatch] = []
    
    private let userID: String
    private let context: NSManagedObjectContext
    
    init(userID: String,
         context: NSManagedObjectContext = PersistanceProvider.shared.mainContext) {
        self.userID = userID
        self.context = context
        loadData()
    }
    
    private func loadData() {
        let userPredicate = NSPredicate(format: "id = %@", userID)
        let matchPredicate = NSPredicate(format: "playerId = %@", userID)
        user = try? context.fetchOne(type: UserProfile.self, predicate: userPredicate)
        let matches = try? context.fetchAll(type: RecentMatch.self, predicate: matchPredicate,
                                            sortDescriptors: [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: true)],
                                            limit: 10)
        self.matches = matches ?? []
    }
    
    
}
