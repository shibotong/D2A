//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData

class MatchListViewModel: ObservableObject {
    @Published var matches: [RecentMatch] = []
    private var isLoading = false
    private var userid: String
    
    init(userid: String) {
        self.userid = userid
        self.loadmatch(userid: userid)
    }
    
    private func loadmatch(userid: String) {
        let managedObject = CoreDataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentMatch")
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        request.predicate = NSPredicate(format: "playerId == %d", Int64(userid)!)
        do {
            let matches = try managedObject.fetch(request) as! [RecentMatch]
            if matches.isEmpty {
                OpenDotaController.loadRecentMatch(userid: userid, offSet: 0, limit: 5) { recentmatches in
                    self.matches = recentmatches
                }
            } else {
                self.matches = matches
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func fetchMoreData() {
        if !self.isLoading {
            self.isLoading = true
            OpenDotaController.loadRecentMatch(userid: userid, offSet: matches.count, limit: 5) { recentmatches in
                self.matches.append(contentsOf: recentmatches)
                self.isLoading = false
            }
        }
    }
}
