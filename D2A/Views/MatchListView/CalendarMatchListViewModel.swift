//
//  CalendarMatchListViewModel.swift
//  App
//
//  Created by Shibo Tong on 12/6/2022.
//

import Combine
import Foundation

class CalendarMatchListViewModel: ObservableObject {
    @Published var selectDate: Date = Date()
    @Published var isLoading = false
    @Published var matches: [RecentMatch] = []
    let userid: String
    private var cancellableSet: Set<AnyCancellable> = []

    init(userid: String) {
        self.userid = userid
        isLoading = true
        $selectDate
            .map { [weak self] date in
                self?.isLoading = true
                let filteredMatches = self?.filterMatch(on: date)
                self?.isLoading = false
                return filteredMatches ?? []
            }
            .sink { [weak self] filteredMatches in
                self?.matches = filteredMatches
            }
            .store(in: &cancellableSet)
    }

    private func filterMatch(on date: Date) -> [RecentMatch] {
        print("select Date \(date.description)")
        let matches = RecentMatch.fetch(userID: userid, on: date)
        return matches
    }
}
