//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import Foundation
import SwiftUI

class MatchViewModel: ObservableObject {
    @Published var error: Error?
    @Published var match: Match?
    @Published var id: String?
    
    init(matchid: String?) {
        self.id = matchid
    }
    
    func loadMatch() async {
        guard let id = self.id else {
            return
        }
        if let match = Match.fetch(id: Int(id) ?? 0) {
            await self.showMatch(match)
        } else {
            await refreshMatch()
        }
    }
    
    func refreshMatch() async {
        guard let id = self.id else {
            return
        }
        do {
            let match = try await OpenDotaController.shared.loadMatchData(matchid: id)
            await self.showMatch(match)
        } catch {
            self.error = error
        }
    }
    
    @MainActor private func showMatch(_ match: Match) {
        self.match = match
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return HeroDatabase.shared.fetchGameMode(id: id)
    }
    
    func fetchGameRegion(id: String) -> LocalizedStringKey {
        return LocalizedStringKey(HeroDatabase.shared.fetchRegion(id: id))
    }
}
