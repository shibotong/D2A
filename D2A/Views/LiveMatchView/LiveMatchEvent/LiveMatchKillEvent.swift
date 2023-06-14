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
    
    private let heroDatabase: HeroDatabase
    
    init(time: Int, kill: [Int], died: [Int], players: LiveMatchPlayers, heroDatabase: HeroDatabase = HeroDatabase.shared) {
        self.time = time
        self.kill = kill
        self.died = died
        self.players = players
        self.heroDatabase = heroDatabase
    }
    
    func generateEvent() -> [LiveMatchEventItem] {
        if kill.count == 1 && !died.isEmpty {
            
            // Only one hero kill others
            guard let killHero = kill.first,
                  let isRadiant = players.heroIDisRadiant(killHero) else {
                return []
            }
            let details: [LiveMatchEventDetail] = died.compactMap { heroID in
                guard let diedHeroIsRadiant = players.heroIDisRadiant(heroID), diedHeroIsRadiant != isRadiant else {
                    return nil
                }
                let heroName = try? heroDatabase.fetchHeroWithID(id: heroID).heroNameLocalized
                return LiveMatchEventDetail(type: .killDied, itemName: heroName, itemIcon: AnyView(
                    HeroImageView(heroID: heroID, type: .icon)
                        .frame(width: 20, height: 20)
                ))
            }
            return details.isEmpty ? [] : [LiveMatchEventItem(time: time, isRadiantEvent: isRadiant, icon: "\(killHero)_icon", events: details)]
        } else if kill.count == 2 && players.heroIDisRadiant(kill.first!) != players.heroIDisRadiant(kill.last!) {
            
            // Can determine which hero kills which hero
            let eventItems: [LiveMatchEventItem] = kill.compactMap { killHeroID in
                guard let isRadiant = players.heroIDisRadiant(killHeroID) else {
                    return nil
                }
                let enemyHero = fetchEnemyHero(killHero: killHeroID)
                let details = enemyHero.map { heroID in
                    let heroName = try? heroDatabase.fetchHeroWithID(id: heroID).heroNameLocalized
                    return LiveMatchEventDetail(type: .killDied, itemName: heroName, itemIcon: AnyView(
                        HeroImageView(heroID: heroID, type: .icon)
                            .frame(width: 20, height: 20)
                    ))
                }
                return details.isEmpty ? nil : LiveMatchEventItem(time: time, isRadiantEvent: isRadiant, icon: "\(killHeroID)_icon", events: details)
            }
            return eventItems
        } else if !died.isEmpty {
            
            // Can't determine which hero kills which hero
            let killEvents: [LiveMatchEventItem] = kill.compactMap { heroID in
                guard let isRadiant = players.heroIDisRadiant(heroID) else {
                    return nil
                }
                let detail = LiveMatchEventDetail(type: .kill, itemName: nil, itemIcon: nil)
                return LiveMatchEventItem(time: time, isRadiantEvent: isRadiant, icon: "\(heroID)_icon", events: [detail])
            }
            
            let diedEvents: [LiveMatchEventItem] = died.compactMap { heroID in
                guard let isRadiant = players.heroIDisRadiant(heroID) else {
                    return nil
                }
                let detail = LiveMatchEventDetail(type: .died, itemName: nil, itemIcon: nil)
                return LiveMatchEventItem(time: time, isRadiantEvent: isRadiant, icon: "\(heroID)_icon", events: [detail])
            }
            var events: [LiveMatchEventItem] = []
            events.append(contentsOf: killEvents)
            events.append(contentsOf: diedEvents)
            return events
        }
        return []
    }
    
    private func fetchEnemyHero(killHero: Int) -> [Int] {
        let isRadiant = players.heroIDisRadiant(killHero)
        return died.filter({ return players.heroIDisRadiant($0) != isRadiant })
    }
}
