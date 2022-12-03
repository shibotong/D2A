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
            return storedPlayers.sorted(by: { $0.netWorth ?? 0 >= $1.netWorth ?? 0 })
        case .heroDamage:
            return storedPlayers.sorted(by: { $0.heroDamage ?? 0 >= $1.heroDamage ?? 0 })
        case .kills:
            return storedPlayers.sorted(by: { $0.kills >= $1.kills })
        case .towerDamage:
            return storedPlayers.sorted(by: { $0.towerDamage ?? 0 >= $1.towerDamage ?? 0 })
        }
    }
    
    func fetchPlayerValue(player: Player) -> Int {
        switch selection {
        case .golds:
            return Int(player.netWorth ?? 0)
        case .heroDamage:
            return Int(player.heroDamage ?? 0)
        case .kills:
            return Int(player.kills)
        case .towerDamage:
            return Int(player.towerDamage ?? 0)
        }
    }
    
    func calculatePercentage(player: Player) -> Double {
        return Double(fetchPlayerValue(player: player)) / Double(fetchMaxValue())
    }
    
    private func fetchMaxValue() -> Int {
        switch selection {
        case .golds:
            return Int(players?.first?.netWorth ?? 0)
        case .heroDamage:
            return Int(players?.first?.heroDamage ?? 0)
        case .kills:
            return Int(players?.first?.kills ?? 0)
        case .towerDamage:
            return Int(players?.first?.towerDamage ?? 0)
        }
    }
}
