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
        self.loadmatch()
    }
    
    private func loadmatch() {
        self.matches = CoreDataController.shared.fetchUserRecentMatch(userid: userid)
    }
    
    func fetchMoreData() {
        if !self.isLoading {
            self.isLoading = true
            OpenDotaController.loadRecentMatch(userid: userid, offSet: matches.count, limit: 5) { result in
                self.loadmatch()
            }
        }
    }
    
    func refreshData() {
        let firstMatch = CoreDataController.shared.fetchUserRecentMatch(userid: userid).first!
        let today = Date()
        let days = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(timeIntervalSince1970: TimeInterval(firstMatch.startTime)), to: today)
        
        let dayCount = Double(days.day!) + (Double(days.hour!) / 24.0) + (Double(days.minute!) / 60.0 / 24.0)
        print(dayCount)
        OpenDotaController.loadRecentMatch(userid: userid, days: dayCount) { bool in
            self.loadmatch()
        }
    }
}
