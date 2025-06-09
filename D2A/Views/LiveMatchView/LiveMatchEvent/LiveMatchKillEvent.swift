//
//  LiveMatchKillEvent.swift
//  D2A
//
//  Created by Shibo Tong on 11/6/2023.
//

import Foundation
import SwiftUI

struct LiveMatchPlayers {

    static let preview: LiveMatchPlayers = .init(radiant: [1, 2, 3, 4, 5], dire: [6, 7, 8, 9, 10])

    let radiant: [Int]
    let dire: [Int]

    func heroIDisRadiant(_ heroID: Int) -> Bool? {
        if radiant.contains(heroID) {
            return true
        }
        if dire.contains(heroID) {
            return false
        }
        return nil
    }
}

struct LiveMatchKillEvent: LiveMatchEvent {
    var id = UUID()
    var time: Int
    var kill: [Int]
    var died: [Int]

    let players: LiveMatchPlayers

    private let heroDatabase: ConstantProvider

    init(
        time: Int, kill: [Int], died: [Int], players: LiveMatchPlayers,
        heroDatabase: ConstantProvider = ConstantProvider.shared
    ) {
        self.time = time
        self.kill = kill
        self.died = died
        self.players = players
        self.heroDatabase = heroDatabase
    }

    func generateEvent() -> [LiveMatchEventItem] {
        var events: [LiveMatchEventItem] = []
        // radiant killer
        let radiantKillers = kill.filter { id in
            return players.heroIDisRadiant(id) ?? false
        }

        // dire killer
        let direKillers = kill.filter { id in
            guard let isRadiant = players.heroIDisRadiant(id) else {
                return false
            }
            return !isRadiant
        }

        let radiantDied = died.filter { id in
            return players.heroIDisRadiant(id) ?? false
        }

        let direDied = died.filter { id in
            guard let isRadiant = players.heroIDisRadiant(id) else {
                return false
            }
            return !isRadiant
        }

        let radiantKillEvents = generateEventForKiller(
            killers: radiantKillers, deads: direDied, isRadiant: true)
        let direKillEvents = generateEventForKiller(
            killers: direKillers, deads: radiantDied, isRadiant: false)

        events.append(contentsOf: radiantKillEvents)
        events.append(contentsOf: direKillEvents)
        return events
    }

    private func generateEventForKiller(killers: [Int], deads: [Int], isRadiant: Bool)
        -> [LiveMatchEventItem]
    {
        guard killers.count == 1 && !deads.isEmpty else {
            if deads.isEmpty {
                return []
            }
            let killEvents: [LiveMatchEventItem] = killers.compactMap { heroID in
                let detail = LiveMatchEventDetail(type: .kill, itemName: nil, itemIcon: nil)
                return LiveMatchEventItem(
                    time: time, isRadiantEvent: isRadiant, icon: "\(heroID)_icon", events: [detail])
            }

            let diedEvents: [LiveMatchEventItem] = deads.compactMap { heroID in
                let detail = LiveMatchEventDetail(type: .died, itemName: nil, itemIcon: nil)
                return LiveMatchEventItem(
                    time: time, isRadiantEvent: isRadiant, icon: "\(heroID)_icon", events: [detail])
            }
            var events = killEvents
            events.append(contentsOf: diedEvents)
            return events
        }
        guard let killer = killers.first else {
            return []
        }
        let details: [LiveMatchEventDetail] = deads.map { heroID in
            let heroIcon = AnyView(
                HeroImageView(heroID: heroID, type: .icon)
                    .frame(width: 20, height: 20)
            )
            let heroName = try? heroDatabase.fetchHeroWithID(id: heroID).heroNameLocalized
            return LiveMatchEventDetail(type: .killDied, itemName: heroName, itemIcon: heroIcon)
        }

        return [
            LiveMatchEventItem(
                time: time, isRadiantEvent: isRadiant, icon: "\(killer)_icon", events: details)
        ]
    }

    private func fetchEnemyHero(killHero: Int) -> [Int] {
        let isRadiant = players.heroIDisRadiant(killHero)
        return died.filter({ return players.heroIDisRadiant($0) != isRadiant })
    }
}
