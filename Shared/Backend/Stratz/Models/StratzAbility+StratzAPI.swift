//
//  StratzAbility+StratzAPI.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import StratzAPI

extension StratzAbility {
  init?(ability: AbilityQuery.Data.Constants.Ability?) {
    guard let ability, let id = ability.id else {
      logWarn(
        "\(String(describing: ability?.id)) has something error, Please check", category: .stratz)
      return nil
    }

    guard let name = ability.name else {
      logDebug("Ability \(id) doesn't have name", category: .stratz)
      return nil
    }

    self.id = Int(id)
    self.name = name
    language = Language(language: ability.language)
    attributes = ability.attributes?.compactMap { Attribute(attribute: $0) } ?? []
  }
}

extension StratzAbility.Language {
  init?(language: AbilityQuery.Data.Constants.Ability.Language?) {
    guard let language, let name = language.displayName else {
      return nil
    }
    displayName = name
    description = language.description?.compactMap({ $0 }) ?? []
    attributes = language.attributes?.compactMap({ $0 }) ?? []
    lore = language.lore
    aghanimDescription = language.aghanimDescription
    shardDescription = language.shardDescription
    notes = language.notes?.compactMap({ $0 }) ?? []
  }
}

extension StratzAbility.Attribute {
  init?(attribute: AbilityQuery.Data.Constants.Ability.Attribute?) {
    guard let attribute,
      let name = attribute.name,
      let value = attribute.value
    else {
      return nil
    }
    self.name = name
    self.value = value
  }
}
