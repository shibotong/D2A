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
    @Published var matchesOnDate: [RecentMatchCodable] = []
    @Published var isLoading = false
    var matches: [RecentMatchCodable] = []
    let userid: String
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(userid: String) {
        self.userid = userid
        isLoading = true
        Task {
            await loadAllMatches()
        }
        $selectDate
            .map { [weak self] date in
                self?.isLoading = true
                let filteredMatches = self?.filterMatch(on: date)
                self?.isLoading = false
                return filteredMatches ?? []
            }
            .sink { [weak self] filteredMatches in
                self?.matchesOnDate = filteredMatches
            }
            .store(in: &cancellableSet)
    }
    
    func loadAllMatches() async {
//        let matches = await OpenDotaController.shared.loadRecentMatch(userid: userid)
//        self.matches = matches
//        let filteredMatches = self.filterMatch(on: self.selectDate)
//        await self.setMatches(matches: filteredMatches)
    }
    
    @MainActor
    func setMatches(matches: [RecentMatchCodable]) {
        matchesOnDate = matches
        isLoading = false
    }
    
    private func filterMatch(on date: Date) -> [RecentMatchCodable]{
        print("select Date \(date.description)")
        let filteredMatches = matches.filter { match in
            let startTime = date.startOfDay.timeIntervalSince1970
            let endTime = date.endOfDay.timeIntervalSince1970
            return match.startTime >= Int(startTime) && match.startTime <= Int(endTime)
        }
        return filteredMatches
    }
}
