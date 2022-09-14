//
//  AnalysisViewModel.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import Foundation
import Combine

class AnalysisViewModel: ObservableObject {
    @Published var players: [Player]?
    private var storedPlayers: [Player]
    @Published var selection: AnalysisType = .kills
    private var cancellableSet: Set<AnyCancellable> = []
    init(player: [Player]) {
        self.storedPlayers = player
        $selection
            .receive(on: RunLoop.main)
            .map { selection in
                return self.sortPlayer(selection: selection)
                
            }
            .assign(to: \.players, on: self)
            .store(in: &cancellableSet)
    }
    
    func sortPlayer(selection: AnalysisType) -> [Player]? {
        switch selection {
        case .golds:
            if storedPlayers.allSatisfy({ $0.netWorth != nil }) {
                return storedPlayers.sorted(by: { $0.netWorth! >= $1.netWorth! })
            } else {
                return nil
            }
        case .heroDamage:
            if storedPlayers.allSatisfy({ $0.heroDamage != nil }) {
                return storedPlayers.sorted(by: { $0.heroDamage! >= $1.heroDamage! })
            } else {
                return nil
            }
        case .kills:
            return storedPlayers.sorted(by: { $0.kills >= $1.kills })
        case .towerDamage:
            if storedPlayers.allSatisfy({ $0.towerDamage != nil }) {
                return storedPlayers.sorted(by: { $0.towerDamage! >= $1.towerDamage! })
            } else {
                return nil
            }
        }
    }
    
    func fetchPlayerValue(player: Player) -> Int {
        switch selection {
        case .golds:
            return player.netWorth ?? 0
        case .heroDamage:
            return player.heroDamage ?? 0
        case .kills:
            return player.kills
        case .towerDamage:
            return player.towerDamage ?? 0
        }
    }
    
    func calculatePercentage(player: Player) -> Double {
        return Double(fetchPlayerValue(player: player)) / Double(fetchMaxValue())
    }
    
    private func fetchMaxValue() -> Int {
        switch selection {
        case .golds:
            return players?.first?.netWorth ?? 0
        case .heroDamage:
            return players?.first?.heroDamage ?? 0
        case .kills:
            return players?.first?.kills ?? 0
        case .towerDamage:
            return players?.first?.towerDamage ?? 0
        }
    }
}
