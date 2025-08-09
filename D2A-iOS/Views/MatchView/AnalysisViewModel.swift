//
//  AnalysisViewModel.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import Combine
import Foundation

class AnalysisViewModel: ObservableObject {
    @Published var players: [PlayerRowViewModel] = []
    private var storedPlayers: [PlayerRowViewModel]
    @Published var selection: AnalysisType = .kills
    private var cancellableSet: Set<AnyCancellable> = []
    init(player: [PlayerRowViewModel]) {
        storedPlayers = player
        $selection
            .receive(on: RunLoop.main)
            .map { [weak self] selection in
                return self?.sortPlayer(selection: selection)

            }
            .sink { [weak self] sortedPlayer in
                guard let self, let sortedPlayer else { return }
                self.players = sortedPlayer
            }
            .store(in: &cancellableSet)
    }

    func sortPlayer(selection: AnalysisType) -> [PlayerRowViewModel]? {
        switch selection {
        case .kills:
            return storedPlayers.sorted(by: { $0.kdaCalculate >= $1.kdaCalculate })
        case .level:
            return storedPlayers.sorted(by: { $0.level >= $1.level })
        case .xpm:
            return storedPlayers.sorted(by: { $0.xpm >= $1.xpm })
        case .gpm:
            return storedPlayers.sorted(by: { $0.gpm >= $1.gpm })
        case .golds:
            return storedPlayers.sorted(by: { $0.netWorth >= $1.netWorth })
        case .heroDamage:
            return storedPlayers.sorted(by: { $0.heroDamage ?? 0 >= $1.heroDamage ?? 0 })
        case .lastHitsDenies:
            return storedPlayers.sorted(by: { $0.level >= $1.level })
        }
    }

    func fetchPlayerValue(player: PlayerRowViewModel) -> Int {
        switch selection {
        case .kills:
            return player.kills
        case .level:
            return player.level
        case .xpm:
            return player.xpm
        case .gpm:
            return player.gpm
        case .golds:
            return player.netWorth
        case .heroDamage:
            return player.heroDamage ?? 0
        case .lastHitsDenies:
            return 0
        }
    }

    func fetchPlayerValueString(player: PlayerRowViewModel) -> String {
        switch selection {
        case .kills:
            return "\(player.kills) / \(player.deaths) / \(player.assists)"
        case .level:
            return player.level.description
        case .xpm:
            return player.xpm.description
        case .gpm:
            return player.gpm.description
        case .golds:
            return player.netWorth.description
        case .heroDamage:
            return player.heroDamage?.description ?? ""
        case .lastHitsDenies:
            return ""
        }
    }

    func calculatePercentage(player: PlayerRowViewModel) -> Double {
        return Double(fetchPlayerValue(player: player)) / Double(fetchMaxValue())
    }

    private func fetchMaxValue() -> Int {
        switch selection {
        case .kills:
            return players.first?.kills ?? 0
        case .level:
            return players.first?.level ?? 0
        case .xpm:
            return players.first?.xpm ?? 0
        case .gpm:
            return players.first?.gpm ?? 0
        case .golds:
            return players.first?.netWorth ?? 0
        case .heroDamage:
            return players.first?.heroDamage ?? 0
        case .lastHitsDenies:
            return 0
        }
    }
}
