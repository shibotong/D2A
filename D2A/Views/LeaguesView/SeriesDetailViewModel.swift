//
//  SeriesDetailViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 14/11/2022.
//

import Foundation

class SeriesDetailViewModel: ObservableObject {
    @Published var matches: [Match] = []
    
    var matchIds: [Int]
    
    init(ids: [Int]) {
        matchIds = ids
    }
    
    func loadMatches() async {
        self.matches = []
        for id in matchIds {
            async let searchedMatch = OpenDotaController.shared.loadMatchData(matchid: "\(id)")
            do {
                await addMatches(match: try await searchedMatch)
            } catch {
                print("parse match error")
            }
        }
    }
    
    @MainActor
    private func addMatches(match: Match) {
        self.matches.append(match)
    }
}
