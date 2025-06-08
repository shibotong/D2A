//
//  Ability.swift
//  App
//
//  Created by Shibo Tong on 12/9/21.
//

import CoreData
import Foundation

struct ODAbility: Codable, Identifiable, PersistanceModel {

  var id: Int?

  var name: String?
  var img: String?
  var dname: String?
  var desc: String?
  var attributes: [Attribute]?
  var behavior: StringOrArray?
  var damageType: StringOrArray?
  var bkbPierce: StringOrArray?
  var lore: String?
  var manaCost: StringOrArray?  // mana cost can be String or [String]
  var dispellable: StringOrArray?
  var coolDown: StringOrArray?  // CD can be String or [String]
  var targetTeam: StringOrArray?
  var targetType: StringOrArray?

  var imageURL: String? {
    guard
      let imageURL = img?
        .replacingOccurrences(of: "_md", with: "")
        .replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
    else {
      return nil
    }
    return "\(IMAGE_PREFIX)\(imageURL)"
  }

  enum CodingKeys: String, CodingKey {
    case img = "img"
    case dname
    case desc
    case attributes = "attrib"
    case behavior
    case damageType = "dmg_type"
    case bkbPierce = "bkbpierce"
    case lore
    case manaCost = "mc"
    case dispellable
    case coolDown = "cd"
    case targetTeam = "target_team"
    case targetType = "target_type"
  }

  var dictionaries: [String: Any] {
    guard let id, let name, let dname else {
      return [:]
    }
    var result: [String: Any] = [:]
    result["id"] = id
    result["name"] = name
    result["displayName"] = dname
    if let img = img {
      result["img"] = img
    }
    if let desc = desc {
      result["desc"] = desc
    }
    if let targetType = targetType?.transformString() {
      result["targetType"] = targetType
    }
    if let behavior = behavior?.transformString() {
      result["behavior"] = behavior
    }
    if let bkbPierce = bkbPierce?.transformString() {
      result["bkbPierce"] = bkbPierce
    }
    if let dispellable = dispellable?.transformString() {
      result["dispellable"] = dispellable
    }
    if let manaCost = manaCost?.transformString() {
      result["manaCost"] = manaCost
    }
    if let coolDown = coolDown?.transformString() {
      result["coolDown"] = coolDown
    }
    if let targetTeam = targetTeam?.transformString() {
      result["targetTeam"] = targetTeam
    }
    if let lore {
      result["lore"] = lore
    }

    if let attributes {
      result["attributes"] = attributes.map { AbilityAttribute(attribute: $0) }
    }
    return result
  }

  func update(context: NSManagedObjectContext) throws -> NSManagedObject {
    guard let abilityID = id else {
      throw D2AError(message: "No ability ID for \(self)")
    }
    let ability = Ability.fetch(id: abilityID, context: context) ?? Ability(context: context)
    setIfNotEqual(entity: ability, path: \.id, value: Int32(abilityID))
    setIfNotEqual(entity: ability, path: \.name, value: name)
    setIfNotEqual(entity: ability, path: \.behavior, value: behavior?.transformString())
    setIfNotEqual(entity: ability, path: \.bkbPierce, value: bkbPierce?.transformString())
    setIfNotEqual(entity: ability, path: \.coolDown, value: coolDown?.transformString())
    setIfNotEqual(entity: ability, path: \.damageType, value: damageType?.transformString())
    setIfNotEqual(entity: ability, path: \.desc, value: desc)
    setIfNotEqual(entity: ability, path: \.dispellable, value: dispellable?.transformString())
    setIfNotEqual(entity: ability, path: \.displayName, value: dname)
    setIfNotEqual(entity: ability, path: \.img, value: img)
    setIfNotEqual(entity: ability, path: \.lore, value: lore)
    setIfNotEqual(entity: ability, path: \.manaCost, value: manaCost?.transformString())
    setIfNotEqual(entity: ability, path: \.targetTeam, value: targetTeam?.transformString())
    setIfNotEqual(entity: ability, path: \.targetType, value: targetType?.transformString())
    setIfNotEqual(
      entity: ability, path: \.attributes,
      value: attributes?.compactMap { AbilityAttribute(attribute: $0) })
    return ability
  }
}

enum StringOrArray: Codable {
  case string(String)
  case array([String])

  init(from decoder: Decoder) throws {
    if let string = try? decoder.singleValueContainer().decode(String.self) {
      self = .string(string)
      return
    }

    if let array = try? decoder.singleValueContainer().decode([String].self) {
      self = .array(array)
      return
    }
    throw Error.couldNotFindStringOrArray
  }

  enum Error: Swift.Error {
    case couldNotFindStringOrArray
  }

  func transformString() -> String? {
    switch self {
    case .string(let string):
      return string
    case .array(let array):
      if array.contains("Point Target") {
        return "Point Target"
      }
      if array.contains("Unit Target") {
        return "Unit Target"
      }
      if array.contains("No Target") {
        return "No Target"
      }
      return array.joined(separator: " / ")
    }
  }
}

struct AbilityContainer: Identifiable {
  var id = UUID()
  var ability: ODAbility
  var heroID: Int
  var abilityName: String
}
