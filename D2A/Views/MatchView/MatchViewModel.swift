//
//  MatchViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 18/2/2024.
//

import Foundation
import CoreData
import SwiftUI

class MatchViewModel: ObservableObject {
    
    private let controller: PersistenceController
    private let data: HeroDatabase
    
    var matchID: String?
    
    @Published var startTime: LocalizedStringKey = ""
    @Published var duration: LocalizedStringKey = ""
    @Published var mode: LocalizedStringKey = ""
    @Published var region: LocalizedStringKey = ""
    
    @Published var goldDiff: [NSNumber]?
    @Published var xpDiff: [NSNumber]?
    @Published var playerRowViewModels: [PlayerRowViewModel] = []
    @Published var radiantKill = 0
    @Published var direKill = 0
    @Published var radiantWin = true
    @Published var maxDamage = 0
    
    @Published var loading = false
    @Published var error = false
    
    init(matchID: String?,
         persistenceController: PersistenceController = PersistenceController.shared,
         data: HeroDatabase = HeroDatabase.shared) {
        self.matchID = matchID
        self.controller = persistenceController
        self.data = data
    }
    
    @MainActor
    private func setLoadingState(_ state: Bool) {
        loading = state
    }
    
    @MainActor
    private func setErrorState(_ state: Bool) {
        error = state
    }
    
    @MainActor
    private func setMatch(match: Match) {
        startTime = match.startTimeString
        duration = LocalizedStringKey(match.durationString)
        mode = LocalizedStringKey(data.fetchGameMode(id: Int(match.mode)).modeName)
        region = LocalizedStringKey(data.fetchRegion(id: match.region.description))
        
        self.goldDiff = match.goldDiff
        self.xpDiff = match.xpDiff
        self.playerRowViewModels = match.allPlayers.map { PlayerRowViewModel(player: $0) }
        self.maxDamage = match.allPlayers
            .sorted(by: { $0.heroDamage ?? 0 > $1.heroDamage ?? 0 })
            .first?.heroDamage ?? 0
    }
    
    func loadMatch() async {
        guard let matchID else {
            await setErrorState(true)
            return
        }
        let match = Match.fetch(id: matchID, controller: self.controller)
        if let match {
            await setMatch(match: match)
        } else {
            do {
                try await loadData(matchID)
            } catch {
                print(error.localizedDescription)
                await setErrorState(true)
                return
            }
            await loadMatch()
        }
    }
    
    private func loadData(_ matchID: String) async throws {
        await setLoadingState(true)
        _ = try await OpenDotaController.shared.loadMatchData(matchid: matchID)
        await setLoadingState(false)
    }
}
