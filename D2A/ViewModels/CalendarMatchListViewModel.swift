//
//  CalendarMatchListViewModel.swift
//  App
//
//  Created by Shibo Tong on 12/6/2022.
//

import Foundation
import Combine

class CalendarMatchListViewModel: ObservableObject {
    @Published var selectDate: Date = Date()
    @Published var matchesOnDate: [RecentMatch] = []
    @Published var isLoading = false
    var matches: [RecentMatch] = []
    let userid: String
    private var cancellableSet: Set<AnyCancellable> = []
    init(userid: String) {
        self.userid = userid
        self.isLoading = true
        Task {
            await self.loadAllMatches()
        }
        $selectDate
            .map { date in
                self.isLoading = true
                let filteredMatches = self.filterMatch(on: date)
                self.isLoading = false
                return filteredMatches
            }
            .assign(to: \.matchesOnDate, on: self)
            .store(in: &cancellableSet)
    }
    
    func loadAllMatches() async {
        let matches = await OpenDotaController.shared.loadRecentMatch(userid: userid)
        self.matches = matches
        let filteredMatches = self.filterMatch(on: self.selectDate)
        await self.setMatches(matches: filteredMatches)
    }
    
    @MainActor
    func setMatches(matches: [RecentMatch]) {
        self.matchesOnDate = matches
        self.isLoading = false
    }
    
    private func filterMatch(on date: Date) -> [RecentMatch]{
        print("select Date \(date.description)")
        let filteredMatches = self.matches.filter { match in
            let startTime = date.startOfDay.timeIntervalSince1970
            let endTime = date.endOfDay.timeIntervalSince1970
            return match.startTime >= Int(startTime) && match.startTime <= Int(endTime)
        }
        return filteredMatches
    }
}
