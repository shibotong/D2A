//
//  EventsListView.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import SwiftUI

struct EventsListView: View {
    
    var events: [Event]
    var players: [Player]
    
    var body: some View {
        VStack {
            ForEach(events, id:\.time) { eventTime in
                ForEach(eventTime.events, id: \.id) { event in
                    if let tower = event as? BuildingEvent {
                        BuildingEventView(event: tower)
                    } else if let kill = event as? KillEvent {
                        buildKillEvent(kill: kill)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .padding(.top, 15)
    }
    
    @ViewBuilder private func buildKillEvent(kill: KillEvent) -> some View {
        if kill.kill.count == 1 && !kill.died.isEmpty {
            KillEventView(kill: kill.kill.first!,
                          died: kill.died,
                          isRadiant: heroIsRadiant(heroID: kill.kill.first!),
                          isKill: true,
                          time: kill.time)
        } else if kill.kill.count == 2 && (heroIsRadiant(heroID: kill.kill.first!) != heroIsRadiant(heroID: kill.kill.last!)) {
            let firstEnemyHeroes = fetchEnemyHero(killHero: kill.kill.first!, diedHeroes: kill.died)
            KillEventView(kill: kill.kill.first!,
                          died: firstEnemyHeroes,
                          isRadiant: heroIsRadiant(heroID: kill.kill.first!),
                          isKill: true,
                          time: kill.time)
            let lastEnemyHeroes = fetchEnemyHero(killHero: kill.kill.last!, diedHeroes: kill.died)
            KillEventView(kill: kill.kill.last!,
                          died: lastEnemyHeroes,
                          isRadiant: heroIsRadiant(heroID: kill.kill.last!),
                          isKill: true,
                          time: kill.time)
        } else if !kill.died.isEmpty {
            ForEach(kill.kill, id: \.self) { killHeroID in
                KillEventView(kill: killHeroID,
                              died: nil,
                              isRadiant: heroIsRadiant(heroID: killHeroID),
                              isKill: true,
                              time: kill.time)
            }
            ForEach(kill.died, id: \.self) { diedHeroID in
                KillEventView(kill: diedHeroID,
                              died: nil,
                              isRadiant: heroIsRadiant(heroID: diedHeroID),
                              isKill: false,
                              time: kill.time)
            }
        }
    }
    
    private func heroIsRadiant(heroID: Int) -> Bool {
        guard let player = players.filter({ $0.heroID == heroID }).first else {
            return false
        }
        return player.slot <= 127
    }
    
    private func fetchEnemyHero(killHero: Int, diedHeroes: [Int]) -> [Int] {
        let isRadiant = heroIsRadiant(heroID: killHero)
        return diedHeroes.filter({ return heroIsRadiant(heroID: $0) != isRadiant })
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(events: [], players: [])
    }
}
