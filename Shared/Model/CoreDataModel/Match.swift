//
//  Match.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import CoreData
import Foundation
import SwiftUI

extension Match {

  static func create(
    id: String,
    lobbyType: Int16 = 1,
    mode: Int16 = 1,
    region: Int16 = 1,
    skill: Int16 = 1,
    duration: Int32 = 1800,
    direKill: Int16 = 30,
    radiantKill: Int16 = 20,
    radiantWin: Bool = true,
    startTime: Date = Date(),
    controller: PersistanceProvider = PersistanceProvider.shared
  ) {
    let viewContext = controller.makeContext(author: "Match")
    let matchCoreData = fetch(id: id) ?? Match(context: viewContext)
    matchCoreData.id = id
    matchCoreData.lobbyType = lobbyType
    matchCoreData.mode = mode
    matchCoreData.region = region
    matchCoreData.skill = skill
    matchCoreData.duration = duration
    matchCoreData.direKill = direKill
    matchCoreData.radiantKill = radiantKill
    matchCoreData.radiantWin = radiantWin
    matchCoreData.startTime = startTime
    matchCoreData.players = [
      Player(id: "0", slot: 0),
      Player(id: "1", slot: 1),
      Player(id: "2", slot: 2),
      Player(id: "3", slot: 3),
      Player(id: "4", slot: 4),
      Player(id: "5", slot: 127),
      Player(id: "6", slot: 128),
      Player(id: "7", slot: 129),
      Player(id: "8", slot: 130),
      Player(id: "9", slot: 131),
    ]
    try? viewContext.save()
  }

  static func create(_ match: ODMatch) throws -> Match {
    let viewContext = PersistanceProvider.shared.makeContext(author: "Match")
    let matchCoreData = fetch(id: match.id.description) ?? Match(context: viewContext)
    matchCoreData.update(match)
    try viewContext.save()
    try viewContext.parent?.save()
    print("save match successfully \(matchCoreData.id ?? "nil")")
    return matchCoreData
  }

  /// Fetch `Match` with `id` in CoreData
  static func fetch(id: String) -> Match? {
    let viewContext = PersistanceProvider.shared.container.viewContext
    let fetchMatch: NSFetchRequest<Match> = Match.fetchRequest()
    let predicate = NSPredicate(format: "id == %@", id)
    fetchMatch.predicate = predicate

    let results = try? viewContext.fetch(fetchMatch)
    return results?.first
  }

  static func delete(id: String) {
    guard let match = fetch(id: id) else {
      return
    }
    let viewContext = PersistanceProvider.shared.container.viewContext
    viewContext.delete(match)
    print("delete \(id) success")
  }

  var allPlayers: [Player] {
    return players ?? []
  }

  var durationString: String {
    return Int(duration).toDuration
  }

  var startTimeString: LocalizedStringKey {
    return startTime?.toTime ?? ""
  }

  func fetchPlayers(isRadiant: Bool) -> [Player] {
    guard let players = players else {
      return []
    }
    let filteredPlayers = players.filter { isRadiant ? $0.slot <= 127 : $0.slot > 127 }
    return filteredPlayers
  }

  func update(_ match: ODMatch) {
    id = match.id.description

    // Match data
    direKill = Int16(match.direKill ?? 0)
    radiantKill = Int16(match.radiantKill ?? 0)
    duration = Int32(match.duration)
    radiantWin = match.radiantWin

    // Lobby data
    lobbyType = Int16(match.lobbyType)
    mode = Int16(match.mode)
    region = Int16(match.region)
    skill = Int16(match.skill ?? 0)
    startTime = Date(timeIntervalSince1970: TimeInterval(match.startTime))
    players = match.players.map { Player(player: $0) }

    goldDiff = match.goldDiff as [NSNumber]?
    xpDiff = match.xpDiff as [NSNumber]?
  }
}
